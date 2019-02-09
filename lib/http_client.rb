require 'net/http'

class HTTPClient
  def get(url)
    parsed_url = URI.parse(url)
    Net::HTTP.start(parsed_url.host, parsed_url.port, :use_ssl => true) do |http|
      http.request Net::HTTP::Get.new(parsed_url)
    end
  end
end
