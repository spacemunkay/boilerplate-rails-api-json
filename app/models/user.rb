class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :rememberable, confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :trackable, :validatable
end
