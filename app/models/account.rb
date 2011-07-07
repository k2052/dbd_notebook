require 'digest/sha1'
class Account
  include MongoMapper::Document
  attr_accessor :password

  # Keys
  key :name,             String
  key :surname,          String
  key :email,            String
  key :crypted_password, String
  key :salt,             String
  key :role,             String

  # Validations   
  validates_presence_of     :email 
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i             

  # Callbacks
  before_save :generate_password    
  
  ##
  # Collection Methods
  #
  
  ##
  # This method is for authentication purpose
  #
  def self.authenticate(email, password)
    enc_password =  Digest::SHA1.hexdigest([email, password, ENV['PASS_SALT_SECRET']].join('::'))  
    account = self.first(:email => email) if email.present?
    account && account.crypted_password == Digest::SHA1.hexdigest([enc_password, account.salt].join('::')) ? account : nil
  end

  private       
    def generate_password
      return if password.blank?
      self.salt             = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new_record?
      password_pre_crypt    = Digest::SHA1.hexdigest([self.email, self.password, ENV['PASS_SALT_SECRET']].join('::'))
      self.crypted_password = Digest::SHA1.hexdigest([password_pre_crypt, self.salt].join('::'))
    end

    def password_required
      crypted_password.blank? || !password.blank?
    end       
end