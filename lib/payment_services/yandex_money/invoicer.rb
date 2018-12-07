require_relative 'invoice'

class PaymentServices::YandexMoney
  class Invoicer < ::PaymentServices::Base::Invoicer
    def create_invoice(money)
    end

    def invoice_form_data
      description = I18n.t('payment_systems.personal_payment', order_id: order.public_id)
      {
        url: 'https://money.yandex.ru/quickpay/confirm.xml',
        method: 'POST',
        target: '_blank',
        inputs: {
          receiver: order.income_wallet.account,
          formcomment: description,
          shortvalue: description,
          targets: description,
          label: order.public_id,
          sum: order.invoice_money.to_f,
          paymentType: 'PC',
          'quickpay-form' => 'shop'
        }
      }
    end
  end
end
