BlueSky = DelegateClass(Minisky) do
  BSKY_HOST = "api.bsky.app"
  alias_method :client, :__getobj__

  def self.build(host = BSKY_HOST, **options)
    new Minisky.new(host, nil, options)
  end

  # client = BlueSky.build("other.pds.host", id:, pass:) # Allow creating ad-hoc authenticated clients.
  # client = BlueSky.new FakeMinisky.new("example.com")  # Allow injecting a stubbed Minisky for testing.
  delegate :new, :build, to: :class

  def profile_metadata(handle)
    get_request("app.bsky.actor.getProfile", { actor: handle })
  end
end.build
