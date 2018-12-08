class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save{self.email = email.downcase}
  before_create :create_activation_digest
  validates :email, presence: true,
    length: {maximum: Settings.user.email_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :name, presence: true, length: {maximum: Settings.user.name_length}
  validates :password, presence: true,
    length: {minimum: Settings.user.password_length}, allow_nil: true
  has_secure_password
end
