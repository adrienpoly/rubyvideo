class Cue
  attr_reader :start_time, :end_time, :text

  def initialize(start_time, end_time, text)
    @start_time = start_time
    @end_time = end_time
    @text = text
  end

  def to_s
    "#{start_time} --> #{end_time}\n#{text}"
  end

  def to_h
    {
      start_time: start_time,
      end_time: end_time,
      text: text
    }
  end
end
