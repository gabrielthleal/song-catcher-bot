require 'net/http'

class Request 
  ENDPOINTS = {
    token_uri: 'https://accounts.spotify.com/api/token',
    authorization_uri: 'https://accounts.spotify.com/authorize',
    spotify_api_uri: 'https://api.spotify.com/v1',
    telegram_api_uri: "https://api.telegram.org/bot#{ENV['TELEGRAM_BOT_TOKEN']}"
  }.freeze

  private_class_method :new

  def self.execute(method, endpoint, path, options)
    new(method, endpoint, path, options).connection
  end

  #
  # <Description>
  #
  # @param [string] method get or post
  # @param [symbol] endpoint must be :token_uri, authorization_uri or spotify_api_uri
  # @param [string] path
  # @param [hash] options params and headers
  # @option options [hast] :params <description>
  # @option options [hash] :headers <description>
  #
  def initialize(method, endpoint, path, options = {})
    @method = method.to_s.capitalize
    @endpoint = ENDPOINTS[endpoint.to_sym]
    @path = path
    @params = options[:params]
    @headers = options[:headers]
  end

  def connection
    url = URI("#{@endpoint}#{@path}")

    url.query = URI.encode_www_form(@params) if @params.present?

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = request_class.new(url)
    request['Authorization'] = @headers[:authorization] if @headers

    if @headers[:content_type].present?
      request['Content-Type'] = @headers[:content_type]
      request.body = @params.to_json
    end

    response = https.request(request)

    JSON.parse(response.read_body) if response.read_body.present?
  end

  private

  def request_class
    @request_class ||= "Net::HTTP::#{@method}".safe_constantize
  end
end
