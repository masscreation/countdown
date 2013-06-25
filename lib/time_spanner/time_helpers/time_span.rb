require 'time_spanner/time_helpers/date_helper'
require 'time_spanner/time_helpers/duration_helper'
require 'time_spanner/time_unit_collector'


#TODO: Remove class when Units are implemented.
module TimeSpanner
  module TimeHelpers

    class TimeSpan

      attr_reader :from, :to, :unit_collector

      attr_reader :nanoseconds
      attr_reader :microseconds
      attr_reader :milliseconds
      attr_reader :seconds
      attr_reader :minutes
      attr_reader :hours
      attr_reader :days
      attr_reader :weeks
      attr_reader :months
      attr_reader :years
      attr_reader :decades
      attr_reader :centuries
      attr_reader :millenniums

      def initialize(from, to, unit_names=[])
        @from = from
        @to   = to

        @unit_collector = TimeUnitCollector.new(from, to, unit_names)

        delegate_calculation
      end

      def delegate_calculation
        # unit_collector.calculate
        case unit_collector.identifier
          when :millenniums_centuries_decades_years_months_weeks_days_hours_minutes_seconds_milliseconds_microseconds_nanoseconds
            calculate_all_units
          when :nanoseconds
            @nanoseconds =  DurationHelper.nanoseconds(from, to)
          when :days
            @days = total_days
          when :months
            @months = total_months
          when :months_days_hours
            calculate_hours_with_days_with_months
          when :months_days
            @months, @days = DurationHelper.months_with_days(from, to)
        end
      end

      def total_microseconds
        DurationHelper.nanoseconds(from, to) / 1000
      end

      def total_milliseconds
        total_microseconds / 1000
      end

      def total_seconds
        total_milliseconds / 1000
      end

      def total_minutes
        total_seconds / 60
      end

      def total_hours
        total_minutes / 60
      end

      def total_days
        total_hours / 24 - leaps
      end

      def total_weeks
        (total_days + leaps) / 7
      end

      def total_months
        DurationHelper.months from, to
      end

      def total_years
        total_days / 365
      end

      def total_decades
        total_years / 10
      end

      def total_centuries
        total_decades / 10
      end

      def total_millenniums
        total_centuries / 10
      end

      def calculate_all_units
        remaining_microseconds, @nanoseconds    = DurationHelper.nanoseconds(from, to).divmod(1000)
        remaining_milliseconds, @microseconds   = remaining_microseconds.divmod(1000)
        remaining_seconds, @milliseconds  = remaining_milliseconds.divmod(1000)
        remaining_minutes, @seconds = remaining_seconds.divmod(60)
        remaining_hours, @minutes   = remaining_minutes.divmod(60)
        remaining_days, @hours      = remaining_hours.divmod(24)

        remaining_days -= leaps

        remaining_years, remaining_days = remaining_days.divmod(365)

        @months, days = DurationHelper.months_with_days(to.to_date-remaining_days, to)

        remaining_decades, @years     = remaining_years.divmod(10)
        remaining_centuries, @decades = remaining_decades.divmod(10)
        @millenniums, @centuries      = remaining_centuries.divmod(10)

        @weeks, @days  = days.divmod(7)
      end

      def calculate_hours_with_days_with_months
        remaining_days, @hours = total_hours.divmod(24)
        remaining_days -= leaps
        @months, @days = DurationHelper.months_with_days(to.to_date-remaining_days, to)
      end


      private

      def leaps
        DateHelper.leap_count from, to
      end

    end
  end

end