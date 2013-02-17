Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :netflix, "287wachcw47ybsu8pdupux7a", "uN7SCD8mZF"
  provider :instapaper, "GGRbfp7qHGkqpMqq43bgTSSXVYv5MqTEeGlrNfTPP7YJXMpesA", "xuOsox2POg3CX0MuvQ1ZM391FKo47K9lrDmG8k0stEUqI7WsJH"
end