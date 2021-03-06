# frozen_string_literal: true

# Copyright (c) 2020 FINFEX https://github.com/finfex

class PaymentServices::CryptoApis
  class Client
    include AutoLogger
    TIMEOUT = 10
    API_URL = 'https://api.cryptoapis.io/v1'

    def initialize(api_key)
      @api_key = api_key
    end

    def address_transactions(currency:, address:)
      safely_parse http_request(
        url: "#{API_URL}/bc/btc/mainnet/address/#{address}/basic/transactions",
        method: :GET
      )
    end

    def transaction_details(transaction_id)
      safely_parse http_request(
        url: "#{API_URL}/bc/btc/mainnet/txs/basic/txid/#{transaction_id}",
        method: :GET
      )
    end

    private

    attr_reader :api_key

    def http_request(url:, method:, body: nil)
      uri = URI.parse(url)
      https = http(uri)
      request = build_request(uri: uri, method: method, body: body)
      logger.info "Request type: #{method} to #{uri} with payload #{request.body}"
      https.request(request)
    end

    def build_request(uri:, method:, body: nil)
      request = if method == :POST
                  Net::HTTP::Post.new(uri.request_uri, headers)
                elsif method == :GET
                  Net::HTTP::Get.new(uri.request_uri, headers)
                else
                  raise "Запрос #{method} не поддерживается!"
                end
      request.body = (body.present? ? body : {}).to_json
      request
    end

    def http(uri)
      Net::HTTP.start(uri.host, uri.port,
                      use_ssl: true,
                      verify_mode: OpenSSL::SSL::VERIFY_NONE,
                      open_timeout: TIMEOUT,
                      read_timeout: TIMEOUT)
    end

    def headers
      {
        'Content-Type': 'application/json; charset=utf-8',
        'Cache-Control': 'no-cache',
        'X-API-Key': api_key
      }
    end

    def safely_parse(response)
      JSON.parse(response.body).with_indifferent_access
    rescue JSON::ParserError => err
      logger.warn "Request failed #{response.class} #{response.body}"
      Bugsnag.notify err do |report|
        report.add_tab(:response, response_class: response.class, response_body: response.body)
      end
      response.body
    end
  end
end
