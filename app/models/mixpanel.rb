# cribbed from mixpanel.com ruby support mixed with pixel drop support
class Mixpanel
  def self.tracking_pixel(event, properties={})
    params = {"event" => event, "properties" => properties.merge('token' => MIXPANEL_CODE[Rails.env])}
    data = ActiveSupport::Base64.encode64s(JSON.generate(params))

    return "http://api.mixpanel.com/track/?data=#{data}&ip=1&img=1"
  end
end