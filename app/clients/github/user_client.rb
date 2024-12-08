module GitHub
  class UserClient < GitHub::Client
    def from_matching(name:)
      if users = search(name, per_page: 5, page: 1).items
        names = Set.new name.downcase.split(/[ -]/)

        users.lazy.map { profile(_1.login) }.
          find { names.subset? Set.new(_1.name&.downcase&.split(/[ -]/)) }
      end
    end

    def profile(username)
      get("/users/#{username}")
    end

    def search(q, per_page: 10, page: 1)
      get("/search/users", query: {q: q, per_page: per_page, page: page})
    end

    def emails
      get("/user/emails")
    end
  end
end
