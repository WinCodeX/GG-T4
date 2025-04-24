class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :validatable, :jwt_authenticatable,
       authentication_keys: [:login],
       jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  has_one_attached :avatar
  enum role: { admin: 0, agent: 1, rider: 2, client: 3 }


  validates :username, presence: true, uniqueness: { case_sensitive: false }

  before_validation :assign_username, on: :create
  before_create :assign_default_role

         attr_writer :login

def login
  @login || self.username || self.email
end


# Override Devise method
def self.find_for_database_authentication(warden_conditions)
  conditions = warden_conditions.dup
  login = conditions.delete(:login)
  where(conditions).where(
    ["lower(username) = :value OR lower(email) = :value", { value: login.strip.downcase }]
  ).first
end


private

def assign_username
  return if username.present?

  base = email.split('@').first.downcase.gsub(/[^a-z0-9]/i, '') # clean name from email
  number = 1

  loop do
    candidate = "#{base}#{format('%04d', number)}"
    unless User.where("LOWER(username) = ?", candidate.downcase).exists?
      self.username = candidate
      break
    end
    number += 1
  end
end


  def assign_default_role
    self.role ||= :client
  end

end

