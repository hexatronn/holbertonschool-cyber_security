require 'net/http'
require 'uri'
require 'json'

def post_request(url, body_params = {})
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == 'https')

  path = uri.path.empty? ? '/' : uri.path
  request = Net::HTTP::Post.new(path)
  
  request['Content-Type'] = 'application/json'
  request.body = body_params.to_json

  response = http.request(request)

  puts "Response status: #{response.code} #{response.message}"
  puts "Response body:"
  
  begin
    parsed_body = JSON.parse(response.body)
    
    if parsed_body.empty?
      puts "{}"
    else
      puts JSON.pretty_generate(parsed_body)
    end
  rescue JSON::ParserError
    puts response.body
  end
end
