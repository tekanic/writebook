Rack::Attack.throttle("subscriptions/ip", limit: 10, period: 1.hour) do |req|
  req.ip if req.path.start_with?("/s/") && req.post?
end

Rack::Attack.throttle("webhooks/ip", limit: 100, period: 1.minute) do |req|
  req.ip if req.path.start_with?("/webhooks/")
end

Rack::Attack.throttle("click_tracking/ip", limit: 60, period: 1.minute) do |req|
  req.ip if req.path.start_with?("/c/")
end
