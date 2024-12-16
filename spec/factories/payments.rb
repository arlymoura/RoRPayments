FactoryBot.define do
  factory :payment do
    external_id { "payment_#{SecureRandom.hex(8)}" }
    amount { 100.0 }
    status { "pending" }
    payment_method { "boleto" }
    association :customer
  end
end
