module PaymentServices
  # Базовый класс для платежного сервиса. Описывает подсервисы и хранит конфигурацию
  #
  class Base
    SUBSERVICES = %i(invoicer importer payout_adapter)

    # Реестр подсервисов
    class Registry
      attr_accessor(*SUBSERVICES)
    end

    class << self
      delegate(*SUBSERVICES, to: :registry)

      def register(type, subservice_class)
        raise "Unknown type #{type}" unless SUBSERVICES.include? type
        raise 'must be a class' unless subservice_class.is_a? Class
        registry.send type.to_s + '=', subservice_class
      end

      def registry
        @registry ||= Registry.new
      end
    end
  end
end
