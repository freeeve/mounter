module Locomotive
  module Mounter

    class MountingPoint

      attr_accessor :resources, :root_page

      # Return all the locales defined by the site related to that mounting point.
      #
      # @return [ Array ] The list of the locales
      #
      def locales
        self.site.locales || []
      end

      # Return the default locale which is the first locale defined for a site.
      # If none, then use the current I18n locale.
      #
      # @return [ Symbol ] The default locale
      #
      def default_locale
        self.locales.first || Locomotive::Mounter.locale
      end

      # Register a resource (site, pages, content types, ...etc) and its elements.
      # It makes sure that all the elements get a pointer to that mounting point.
      # The elements can be either an array, hash or even a single object (ex: site).
      # For instance, for a page, it will be a hash whose key is the fullpath.
      #
      # @param [ Symbol ] name Name of the resource
      # @param [ Object ] elements Element(s) related to the resource
      #
      def register_resource(name, elements)
        self.resources ||= {}

        (elements.respond_to?(:values) ? elements.values : [*elements]).each do |element|
          element.mounting_point = self
        end

        self.resources[name.to_sym] = elements
      end

      def method_missing(name, *args, &block)
        (self.resources || {})[name.to_sym] || super
      end

    end
  end
end