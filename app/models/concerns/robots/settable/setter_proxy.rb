module Robots
  module Settable
    class SetterProxy
      attr_reader :layout, :owner
      delegate :ships, :squares, :to => :owner

      def initialize(options)
        @layout  = options[:layout] || "random"
        @owner   = options[:owner]
      end

      def owner
        @owner
      end

      def set(opts={})
        @layout = opts[:layout] if opts[:layout]
        setter_class.new(owner).layout
        self
      end

      def setter_class
        ("Robots::Settable::" + (@layout + "Setter").classify).constantize
      end

      def random
        @layout = "random"
        set
      end
    end
  end
end

