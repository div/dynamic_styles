require 'active_support/core_ext'

module DynamicStyles
  class Stylesheet

    delegate :precompilation?, :digest, :compiled?, :compile!, :write_template!, :to => :compiler

    def initialize(layout)
      @layout = layout
    end

    def compiler
      AssetCompiler.new(asset_path, scss_path)
    end

    def public_path
      precompilation? ? digested_path : undigested_path
    end

    def base_path
      "#{template_name.pluralize}/#{base_filename}"
    end

    def asset_path
      "#{base_path}.css"
    end

    def scss_path
      "#{base_path}.scss"
    end

    def undigested_path
      "/assets/#{base_path}.css"
    end

    def digested_path
      "/assets/#{base_path}-#{digest}.css"
    end

    def template_name
      @layout.class.to_s.downcase.split('::').last
    end

    def base_filename
      [
        @layout.id,
        @layout.updated_at.to_s(:number),
        template_name
      ].join('-')
    end

    def path
      compile
      public_path
    end

    def compile
      unless compiled?
        write_template!(render_template)
        compile!
        # cleanup
      end
    end

    def render_template
      class_name = @layout.class.to_s
      controller = (class_name.pluralize + "Controller").constantize
      controller.new.render_to_string template_name,
        formats: [:scss],
        layout:  false,
        locals:  { :"#{class_name.downcase}" => @layout }
    end

  end
end