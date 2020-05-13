require 'active_support'
require 'active_support/core_ext/numeric'

class ClockTime
  include Comparable

  attr_reader :hour, :minute

  class << self
    def parse(string)
      if string =~ /\A(\d{2})[^\d]?(\d{2})\z/
        new($1.to_i, $2.to_i)
      else
        raise ArgumentError, 'invalid clock time'
      end
    end
  end

  def initialize(hour, min)
    @hour = hour
    @minute = min
    if !valid_hour? || !valid_minute?
      raise ArgumentError, 'invalid clock time'
    end
  end

  def to_duration
    @hour.hours + @minute.minutes
  end

  def to_time(date)
    midnight = date.to_time
    replace_time(midnight)
  end

  def next_time(base_time)
    t = replace_time(base_time)
    return t + 1.day if t < base_time
    t
  end

  def prev_time(base_time)
    t = replace_time(base_time)
    return t - 1.day if t > base_time
    t
  end

  def replace_time(time)
    time.change(hour: @hour, min: @minute)
  end

  def <=>(clock_time)
    to_duration <=> clock_time.to_duration
  end

  def +(augend)
    if augend.is_a?(self.class)
      augend = augend.to_duration
    end
    to_duration + augend
  end

  def -(minuend)
    if minuend.is_a?(self.class)
      minuend = minuend.to_duration
    end
    to_duration - minuend
  end

  def valid_hour?
    return false unless @hour.is_a?(Integer)
    return true if @hour >= 0 && @hour <= 24
    false
  end

  def valid_minute?
    return false unless @minute.is_a?(Integer)
    return true if @minute >= 0 && @minute <= 60
    false
  end
end

require 'clock_time/span'
