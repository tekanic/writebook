class AdClick < ApplicationRecord
  belongs_to :ad_creative
  belongs_to :delivery, optional: true

  has_secure_token :token

  validates :ip_address, presence: true

  # Block private/internal IPs
  PRIVATE_IP_RANGES = [
    IPAddr.new("10.0.0.0/8"),
    IPAddr.new("172.16.0.0/12"),
    IPAddr.new("192.168.0.0/16"),
    IPAddr.new("127.0.0.0/8"),
    IPAddr.new("::1/128")
  ].freeze

  def self.private_ip?(ip)
    addr = IPAddr.new(ip)
    PRIVATE_IP_RANGES.any? { |range| range.include?(addr) }
  rescue IPAddr::InvalidAddressError
    true
  end
end
