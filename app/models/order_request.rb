class OrderRequest < ApplicationRecord
  before_validation ->{
    self.guid = SecureRandom.uuid
  }
end
