class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_many :created_posts, foreign_key: :creator_id, class_name: "Post" 

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :infriendships, class_name: "Friendship", foreign_key: :user2_id, dependent: :destroy
  has_many :infriends, through: :infriendships, source: :user1 
  has_many :outfriendships, class_name: "Friendship", foreign_key: :user1_id, dependent: :destroy
  has_many :outfriends, through: :outfriendships, source: :user2

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def friends #Change for a query
    infriends + outfriends
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

end
