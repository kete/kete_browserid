# if we are use browserid, email must be unique to the system
User.class_eval do
  validates_uniqueness_of :email, :case_sensitive => false, :message => lambda { I18n.t('user_model.must_be_unique') }

  # a way to check if emails are unique on this system
  def self.has_non_unique_emails?
    count(:select => 'distinct(email)') != count
  end

  attr_accessor :creating_with_browserid
  alias :creating_with_browserid? :creating_with_browserid

  def password_required?
    new_record? &&
      !creating_with_browserid? &&
      (crypted_password.blank? || !password.blank?)
  end
end
