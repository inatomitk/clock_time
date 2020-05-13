require 'clock_time/span'

RSpec.describe ClockTime::Span do
  describe '#self.parse' do
    it 'returns ClockTime::Span instance' do
      s = ClockTime::Span.parse('10:00', '15:00')
      cf = ClockTime.new(10, 0)
      ct = ClockTime.new(15, 0)
      expect(s).to eq(ClockTime::Span.new(cf, ct))
    end
  end

  describe '#initialize' do
    it 'raises exception when args are not ClockTime instance' do
      expect { ClockTime::Span.new(1, 'a') }.to raise_error(ArgumentError)
    end
  end

  describe '#duration' do
    it 'returns to - from duration when from < to' do
      s = ClockTime::Span.new(ClockTime.new(10, 30), ClockTime.new(13, 0))
      expect(s.duration).to eq(2.hours + 30.minutes)
    end
    it 'returns to - from + 24 hours duration when from > to' do
      s = ClockTime::Span.new(ClockTime.new(10, 30), ClockTime.new(9, 0))
      expect(s.duration).to eq(22.hours + 30.minutes)
    end
  end

  describe 'to_times' do
    it 'returns times at same date when from < to' do
      s = ClockTime::Span.new(ClockTime.new(10, 30), ClockTime.new(13, 0))
      date = Date.parse('2020/05/05')
      expect(s.to_times(date)).to eq([
        Time.parse('2020/05/05 10:30'),
        Time.parse('2020/05/05 13:00')
      ])
    end
    it 'returns times at different date when to < from' do
      s = ClockTime::Span.new(ClockTime.new(14, 30), ClockTime.new(13, 0))
      date = Date.parse('2020/05/05')
      expect(s.to_times(date)).to eq([
        Time.parse('2020/05/05 14:30'),
        Time.parse('2020/05/06 13:00')
      ])
    end
  end
end

