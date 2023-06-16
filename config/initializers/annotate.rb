if Rails.env.development?
  require "annotate"
  Annotate.set_defaults wrapper_open: "rubocop:disable Layout/LineLength",
    wrapper_close: "rubocop:enable Layout/LineLength"
end
