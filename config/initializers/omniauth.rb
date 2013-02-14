Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :netflix, "287wachcw47ybsu8pdupux7a", "uN7SCD8mZF"
end