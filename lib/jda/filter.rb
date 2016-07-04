module Jda
  module Filters
    class Base
      attr_reader :index, :matchers

      def initialize(index, matchers = [])
        @index = index.to_i
        @matchers = matchers.to_a
      end

      def match?(row)
        @matchers.include?(val(row))
      end

      private

      def val(row)
        row[@index].strip! || row[@index]
      end
    end

    class Sku < Base
      def initialize(matchers)
        super(0, matchers)
      end
    end

    class Store < Base
      def initialize(matchers)
        super(1, matchers)
      end
    end

    class Sale < Base
      def initialize
        super(14, %w(Y))
      end
    end
  end
end
