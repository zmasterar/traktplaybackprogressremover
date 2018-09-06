class User < ApplicationRecord
  has_one :calendar, dependent: :destroy
end
