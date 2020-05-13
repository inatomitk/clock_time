require 'clock_time'

RSpec.describe ClockTime do
  describe '#self.parse' do
    it 'returns ClockTime instance' do
      expect(ClockTime.parse('12:30')).to eq(ClockTime.new(12, 30))
    end
    it 'raises an exception when argument is invalid' do
      expect { ClockTime.parse('12345') }.to raise_error(ArgumentError)
    end
  end

  describe '#initialize' do
    it 'raises an exception when hour is invalid' do
      expect { ClockTime.new('a', 11) }.to raise_error(ArgumentError)
    end
    it 'raises an exception when minute is invalid' do
      expect { ClockTime.new(5, '22') }.to raise_error(ArgumentError)
    end
  end

  describe '#to_duration' do
    it 'returns ActiveSupport::Duration' do
      c = ClockTime.new(10, 30)
      expect(c.to_duration).to eq(10.hours + 30.minutes)
    end
  end

  describe '#to_time' do
    it 'calls replace_time' do
      date = Date.parse('2020/05/05')
      c = ClockTime.new(10, 30)
      expect(c).to receive(:replace_time)
        .with(Time.parse('2020/05/05 00:00'))

      c.to_time(date)
    end
  end

  describe '#next_time' do
    it 'returns today time when replaced time is greater than base time' do
      c = ClockTime.new(12, 0)
      base_time = Time.parse('2020/05/05 10:00')
      expect(c.next_time(base_time)).to eq(Time.parse('2020/05/05 12:00'))
    end
    it 'returns tomorrow time when replaced time is less than base time' do
      c = ClockTime.new(12, 0)
      base_time = Time.parse('2020/05/05 15:00')
      expect(c.next_time(base_time)).to eq(Time.parse('2020/05/06 12:00'))
    end
  end

  describe '#prev_time' do
    it 'returns today time when replaced time is less than base time' do
      c = ClockTime.new(12, 0)
      base_time = Time.parse('2020/05/05 14:00')
      expect(c.prev_time(base_time)).to eq(Time.parse('2020/05/05 12:00'))
    end
    it 'returns yesterday time when replaced time is greater than base time' do
      c = ClockTime.new(12, 0)
      base_time = Time.parse('2020/05/05 10:00')
      expect(c.prev_time(base_time)).to eq(Time.parse('2020/05/04 12:00'))
    end
  end

  describe '#+' do
    it 'returns time substraction' do
      c1 = ClockTime.new(10, 30)
      c2 = ClockTime.new(5, 40)
      expect(c1 + c2).to eq(16.hours + 10.minutes)
    end
  end

  describe '#-' do
    it 'returns time substraction' do
      c1 = ClockTime.new(10, 30)
      c2 = ClockTime.new(5, 40)
      expect(c1 - c2).to eq(4.hours + 50.minutes)
    end
  end

  describe '#<=>' do
    describe '==' do
      it 'returns true when hour and minute are equal' do
        clock_time1 = ClockTime.new(10, 30)
        clock_time2 = ClockTime.new(10, 30)
        expect(clock_time1).to eq(clock_time2)
      end
      it 'returns false when hour is not equal' do
        clock_time1 = ClockTime.new(10, 30)
        clock_time2 = ClockTime.new(9, 30)
        expect(clock_time1).not_to eq(clock_time2)
      end
      it 'returns false when minute is not equal' do
        clock_time1 = ClockTime.new(10, 30)
        clock_time2 = ClockTime.new(10, 29)
        expect(clock_time1).not_to eq(clock_time2)
      end
    end
    describe '<' do
      it 'returns true when right value is big' do
        clock_time1 = ClockTime.new(10, 30)
        clock_time2 = ClockTime.new(10, 31)
        expect(clock_time1).to be < clock_time2
      end
    end
  end
end
