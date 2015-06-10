class Friendship < ActiveRecord::Base

  # There can only be one friendship, this is why we only catch the first.
  scope :between_users, ->(user_one, user_two) {
    where('(user_id = ? AND friend_id = ?) OR (user_id = ? AND friend_id = ?)', user_one.id, user_two.id, user_two.id, user_one.id)
  }

  validates :user_id, :friend_id, presence: true
  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  def self.request_exists(user_id, receiver_id)
    a = Request.exists?(user_id: receiver_id, receiver_id: user_id)
    b = Request.exists?(user_id: user_id, receiver_id: receiver_id)
    a || b
  end

  def self.friendship_exists(user_id, friend_id)
    a = Friendship.exists?(user_id: friend_id, friend_id: user_id)
    b = Friendship.exists?(user_id: user_id, friend_id: friend_id)
    a || b
  end

  def self.find_friendship(user_id, friend_id)
    Friendship.where("user_id = ? and friend_id = ? OR")
  end
end
