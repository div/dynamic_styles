require 'dynamic_styles'

module DynamicStyles
  describe Stylesheet do
    let(:site) { double 'Site' }
    let(:stylesheet) { Stylesheet.new(site) }
    let(:compiler) { double 'AssetCompiler'}

    before(:each) do
      stylesheet.stub(:base_filename) {'base_name'}
      stylesheet.stub(:template_name) {'site'}
      AssetCompiler.stub(:new) { @compiler }
    end

    it "#base_filename is timestamped with parent model" do
      stylesheet.unstub(:base_filename)
      site.stub(:id) {'-1'}
      site.stub(:updated_at) { Time.new 12345 }
      stylesheet.base_filename.should == "#{site.id}-123450101000000-site"
    end

    it "#asset_path returns relative path from assets dir" do
      stylesheet.asset_path.should == "sites/#{stylesheet.base_filename}.css"
    end

    context "assets not precompiled" do
      before :each do
       stylesheet.stub(:precompilation?) { false }
      end

      it "#public_path returns usual asset path in development" do
        stylesheet.public_path.should == "/assets/sites/#{stylesheet.base_filename}.css"
      end
    end

    context "assets are precompiled" do
      before :each do
        stylesheet.stub(:precompilation?) { true }
      end

      it "#public_filename is digested" do
        compiler = double 'AssetCompiler'
        AssetCompiler.stub(:new) { compiler }
        compiler.stub(:digest) { 987654321 }
        stylesheet.public_path.should == "/assets/sites/#{stylesheet.base_filename}-987654321.css"
      end
      it "asset is recompiled if parent changed" do
        stylesheet.stub(:render_template) { 'asdf'}
        stylesheet.stub(:compiled?) { false }
        stylesheet.should_receive(:write_template!)
        stylesheet.should_receive(:compile!)
        stylesheet.compile
      end
    end

    describe "compilation:" do
      before(:each) do
        @compiler = double 'AssetCompiler'
        AssetCompiler.stub(:new) { @compiler }
      end

      it "#compile! compiles with manifest" do
        @compiler.should_receive(:compile!)
        stylesheet.compile!
      end

      it "#render_template renders and saves to file" do
        @compiler.should_receive(:write_template!)
        stylesheet.write_template!
      end

    end

  end
end