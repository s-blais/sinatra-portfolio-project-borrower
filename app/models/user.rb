class User < ActiveRecord::Base
    has_secure_password
    has_many :items
    validates_presence_of :username, :email #, :password
    # it appears that including :password in the validates_presence_of statement makes User not .updateable, so validation of password presence at User creation must be verified another way, like in the processing of the submitted params

end
