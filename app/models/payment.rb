class Payment < ApplicationRecord
  belongs_to :customer

  validates :external_id, presence: true, uniqueness: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :payment_method, presence: true

  enum status: { initial: 0, processing: 1, approved: 2, rejected: 3, error: 4 }
end
