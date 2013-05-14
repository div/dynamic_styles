module DynamicStyles
  module Mount
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def mount_stylesheet(options = {})
        include DynamicStyles::Mount::LocalInstanceMethods
      end
    end

    module LocalInstanceMethods
      def dynamic_stylesheet
        DynamicStyles::Stylesheet.new(self)
      end
    end
  end
end

ActiveRecord::Base.send :include, DynamicStyles::Mount