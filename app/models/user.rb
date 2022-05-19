class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Gravtastic
  is_gravtastic

  has_many :created_posts, foreign_key: :creator_id, class_name: "Post" 

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :friendships, ->(user){where("user1_id = #{user.id} OR user2_id = #{user.id}")}, class_name: "Friendship"
  has_many :infriendships, class_name: "Friendship", foreign_key: :user2_id, dependent: :destroy 
  has_many :infriends, through: :infriendships, source: :user1 
  has_many :outfriendships, class_name: "Friendship", foreign_key: :user1_id, dependent: :destroy  
  has_many :outfriends, through: :outfriendships, source: :user2
  has_many :infriendships_a, -> {where "status = 'accepted'"}, class_name: "Friendship", foreign_key: :user2_id, dependent: :destroy 
  has_many :infriends_a, through: :infriendships_a, source: :user1 
  has_many :outfriendships_a, -> {where "status = 'accepted'"}, class_name: "Friendship", foreign_key: :user1_id, dependent: :destroy  
  has_many :outfriends_a, through: :outfriendships_a, source: :user2
  has_many :infriendships_r, -> {where "status = 'requested'"}, class_name: "Friendship", foreign_key: :user2_id, dependent: :destroy 
  has_many :infriends_r, through: :infriendships_r, source: :user1 
  has_many :outfriendships_r, -> {where "status = 'requested'"}, class_name: "Friendship", foreign_key: :user1_id, dependent: :destroy  
  has_many :outfriends_r, through: :outfriendships_r, source: :user2

  has_many :comments, foreign_key: :creator_id

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable, authentication_keys: [:login]

	devise :omniauthable, omniauth_providers: %i[facebook]

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def friendships
    infriendships + outfriendships
  end

  def related_people
    infriends + outfriends
  end


  def friends #Change for a query
    infriends_a + outfriends_a
    #User.find_by_sql("SELECT U.* FROM users U INNER JOIN friendships F ON F.user2_id = U.id WHERE F.user1_id = #{id} AND F.status = 'accepted' UNION SELECT U.* FROM users U INNER JOIN friendships F ON F.user1_id = U.id WHERE F.user2_id = #{id} AND F.status = 'accepted'")
  end

  def request_pending_friends
    infriends_r + outfriends_r
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

	def self.from_omniauth(auth)
		puts "from_omniauth"
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			user.email = auth.info.email
			user.password = Devise.friendly_token[0, 20]
			#user.name = auth.info.name   # assuming the user model has a name
			#user.image = auth.info.image # assuming the user model has an image
			# If you are using confirmable and the provider(s) you use validate emails, 
			# uncomment the line below to skip the confirmation emails.
			# user.skip_confirmation!
		end
	end

	  def self.new_with_session(params, session)
			super.tap do |user|
				if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
					user.name = data["name"] if user.name.blank?
					user.email = data["email"] if user.email.blank?
				end
			end
		end

end
