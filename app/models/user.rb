class User < ApplicationRecord
    before_save { self.email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 },
                        format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                        uniqueness: { case_sensitive: false }
    has_secure_password
    
    has_many :microposts
    has_many :favorites
    has_many :favorites_posts, through: :favorites, source: :micropost
    
    def like(micropost)
        favorites.find_or_create_by(micropost_id: micropost.id)
    end

    def unlike(micropost)
        favorite = favorites.find_by(micropost_id: micropost.id)
        favorite.destroy if favorite
    end
    
    def  favorites_post?(micropost)
        self.favorites_posts.include?(micropost)
    end
    
end
