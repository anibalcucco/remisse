class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :password, :password_confirmation

  LOGINS_WITH_EARLY_ACCESS_TO_FEATURES = ['anibalcucco', 'gabodabo'].freeze

  def has_early_access_to_features?
    LOGINS_WITH_EARLY_ACCESS_TO_FEATURES.include? self.login
  end
end
