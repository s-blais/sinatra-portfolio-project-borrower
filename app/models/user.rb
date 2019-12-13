class User < ActiveRecord::Base
    has_secure_password
    has_many :items
    validates_presence_of :username, :email, :has_secure_password

end
