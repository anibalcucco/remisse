class User < ApplicationRecord
  devise :database_authenticatable, :registerable

  LOGINS_WITH_EARLY_ACCESS_TO_FEATURES = ['anibalcucco', 'gabodabo'].freeze

  def has_early_access_to_features?
    LOGINS_WITH_EARLY_ACCESS_TO_FEATURES.include? self.login
  end
end
