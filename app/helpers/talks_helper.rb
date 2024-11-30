module TalksHelper
  def seconds_to_formatted_duration(seconds)
    parts = ActiveSupport::Duration.build(seconds).parts

    values = [parts[:hours], parts.fetch(:minutes, 0), parts.fetch(:seconds, 0)].select(&:present?)

    return "??:??" if values.any?(&:negative?)

    values.map { |value| value.to_s.rjust(2, "0") }.join(":")
  end
end
