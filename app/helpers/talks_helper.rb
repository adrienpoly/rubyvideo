module TalksHelper
  def seconds_to_formatted_duration(seconds)
    values = ActiveSupport::Duration.build(seconds).parts.values

    if values.length == 1
      values.prepend(0)
    end

    values.map { |x| x.to_s.rjust(2, "0") }.join(":")
  end
end
