require 'bcrypt'

class User

  include DataMapper::Resource

  attr_reader :password
  attr_accessor :password_confirmation

  property :id, Serial
  property :email, String, required: true
  # this will store both the password and the salt
  # It's Text and not String because String holds
  # 50 characters by default
  # and it's not enough for the hash and salt
  property :password_digest, Text
  # when assigned the password, we don't store it directly
  # instead, we generate a password digest, that looks like this:
  # "$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa"
  # and save it in the database. This digest, provided by bcrypt,
  # has both the password hash and the salt. We save it to the
  # database instead of the plain password for security reasons.
  property :password_token, Text

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  #Because we have a custom writer for this property, we'll never be storing the plain text password in an instance variable and datamapper will be unable to compare it to the password confirmation.
  end

  def self.authenticate(email, password)
  # that's the user who is trying to sign in
    user = first(email: email)
  # if this user exists and the password provided matches
  # the one we have password_digest for, everything's fine
  #
  # The Password.new returns an object that overrides the ==
  # method. Instead of comparing two passwords directly
  # (which is impossible because we only have a one-way hash)
  # the == method calculates the candidate password_digest from
  # the password given and compares it to the password_digest
  # it was initialised with.
  # So, to recap: THIS IS NOT A STRING COMPARISON
    if user && BCrypt::Password.new(user.password_digest) == password
    # return this user
      user
    else
      nil
    end
  end

  validates_confirmation_of :password
  validates_uniqueness_of :email
  # validates_confirmation_of is a DataMapper method
  # provided especially for validating confirmation passwords
  # The model will not save unless both password
  # and password_confirmation are the same
end
