users.defaults verified: true, password_digest: -> { BCrypt::Password.create("Secret1*3*5*") }

users.create :admin, email: "admin@rubyvideo.dev", admin: true
users.create :lazaro_nixon, email: "lazaronixon@hotmail.com"
