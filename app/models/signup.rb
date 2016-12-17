class Signup < ActiveRecord::Base
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  validates_presence_of :email, message: "You must provide an email."
  validates_format_of :email, with: EMAIL_REGEX, message: "Email doesn't look like an email address."
end
