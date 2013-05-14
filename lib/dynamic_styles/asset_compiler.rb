module DynamicStyles
  class AssetCompiler
    def initialize(asset_path, scss_path=nil)
      @asset_path = asset_path
      @scss_path = Rails.root.join('app', 'assets', 'stylesheets', scss_path)
      @env = Rails.application.assets.instance_variable_get('@environment') if precompilation?
    end

    def precompilation?
      !Rails.application.config.assets.compile
    end

    def compiled?
      if precompilation?
        @env.find_asset(@asset_path).present?
      else
        File.exists?(@scss_path) && !File.zero?(@scss_path)
      end
    end

    def digest
      @env.find_asset(@asset_path).digest
    end

    def manifest_path
      File.join(Rails.public_path, Rails.application.config.assets.prefix)
    end

    def compile!
      if precompilation?
        Sprockets::Manifest.new(@env, self.manifest_path).compile(@asset_path)
      end
    end

    def write_template!(string)
      File.open(@scss_path, 'w') { |f| f.write(string) }
    end
  end
end