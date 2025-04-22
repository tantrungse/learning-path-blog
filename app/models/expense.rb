class Expense < ApplicationRecord
  has_one_attached :receipt
end
