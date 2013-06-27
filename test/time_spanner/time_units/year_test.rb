require 'test_helper'
require 'date'

module TimeSpanner
  module TimeUnits

    class YearTest < TestCase
      include TimeHelpers

      it 'initializes' do
        year = Year.new

        assert year.kind_of?(TimeUnit)
        assert_equal 4, year.position
      end

      it 'calculates without rest' do
        starting_time = DateTime.parse('2013-04-01 00:00:00')
        target_time   = DateTime.parse('2015-04-01 00:00:00')
        year          = Year.new

        year.calculate(starting_time, target_time)

        assert_equal 2, year.amount
        assert_equal 0, year.rest
      end

      it 'calculates with rest (11 months in nanoseconds)' do
        starting_time = DateTime.parse('2013-01-01 00:00:00')
        target_time   = DateTime.parse('2015-12-01 00:00:00')
        year          = Year.new

        year.calculate(starting_time, target_time)

        assert_equal 2, year.amount
        assert_equal 28857600000000000, year.rest
      end

    end
  end
end