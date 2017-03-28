use Mix.Config

config :extwitter, :oauth, [
  consumer_key: "Your Twitter consumer key",
  consumer_secret: "Your Twitter consumer secret",
  access_token: "Your Twitter access token",
  access_token_secret: "Your Twitter access token secret"
]

import_config "config.secret.exs"
