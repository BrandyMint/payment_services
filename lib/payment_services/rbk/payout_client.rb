# frozen_string_literal: true

# Copyright (c) 2018 FINFEX https://github.com/finfex

require_relative 'client'

class PaymentServices::RBK
  class PayoutClient < PaymentServices::RBK::Client
    URL = 'https://api.rbk.money/wallet/v0/withdrawals'

    def make_payout(payout_destination:, wallet:, amount_cents:)
      safely_parse http_request(
        url: URL,
        method: :POST,
        body: {
          wallet: wallet.rbk_id,
          destination: payout_destination.rbk_id,
          body: {
            amount: amount_cents,
            currency: 'RUB' # RBK выводит только рубли
          }
        }
      )
    end
  end
end
