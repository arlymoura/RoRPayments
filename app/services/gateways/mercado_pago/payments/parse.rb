module Gateways
  module MercadoPago
    module Payments
      class Parse
        STATUSES = {
          pending: :processing,
          approved: :approved,
          authorized: :processing,
          in_process: :processing,
          in_mediation: :approved,
          rejected: :rejected,
          cancelled: :expired,
          refunded: :approved,
          charged_back: :approved
        }.with_indifferent_access

        MOTIVES = {
          cc_rejected_bad_filled_date: :data,
          cc_rejected_bad_filled_other: :data,
          cc_rejected_bad_filled_security_code: :data,
          cc_rejected_blacklist: :risk,
          cc_rejected_call_for_authorize: :blocked,
          cc_rejected_card_disabled: :blocked,
          cc_rejected_duplicated_payment: :risk,
          cc_rejected_high_risk: :risk,
          cc_rejected_insufficient_amount: :balance,
          cc_rejected_invalid_installments: :data,
          cc_rejected_max_attempts: :risk,
          cc_rejected_other_reason: :other,
          pending_review_manual: nil,
          pending_contingency: nil,
          accredited: nil
        }.with_indifferent_access

        def initialize(data)
          @data = data.with_indifferent_access
        end

        def call
          Gateways::Payment.new({
            id: get(:id),
            status: status,
            motive: motive,
            motive_detail: motive_detail,
            approved_at: time(:date_approved),
            expires_at: time(:date_of_expiration),
            info: {
              qr_code: qr_code,
              barcode: barcode,
              url: url
            }
          })
        end

        private

        def get(*args)
          @data.dig(*args)
        end

        def status
          STATUSES[get(:status)]
        end

        def motive
          MOTIVES[get(:status_detail)]
        end

        def motive_detail
          get(:status_detail)
        end

        def time(*args)
          Time.zone.parse(get(*args))
        rescue StandardError
          nil
        end

        def qr_code
          get(:point_of_interaction, :transaction_data, :qr_code)
        end

        def barcode
          get(:barcode, :content)
        end

        def url
          get(:transaction_details, :external_resource_url)
        end
      end
    end
  end
end
