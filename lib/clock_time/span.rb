class ClockTime::Span
  attr_reader :from, :to

  class << self
    def parse(from_string, to_string)
      from = ClockTime.parse(from_string)
      to = ClockTime.parse(to_string)
      new(from, to)
    end
  end

  def initialize(from, to)
    if !from.is_a?(ClockTime) || !to.is_a?(ClockTime)
      raise ArgumentError, 'invalid span'
    end
    @from = from
    @to = to
  end

  def duration
    return @to - @from + 24.hours if @to < @from
    @to - @from
  end

  def to_times(date)
    from_t = from.to_time(date)
    to_t = to.next_time(from_t)
    return [from_t, to_t]
  end

  def ==(span)
    from == span.from && to == span.to
  end
end
