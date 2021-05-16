class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def stock_already_followed?(ticker_symbol)
    stock = Stock.check_db(ticker_symbol)

    return false unless stock

    stocks.where(id: stock.id).exists?
  end

  def under_stock_limit?
    stocks.count < 10
  end

  def can_follow_stock?(ticker_symbol)
    under_stock_limit? && !stock_already_followed?(ticker_symbol)
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name

    'Anonymous'
  end

  def self.search(param)
    param.strip!
    to_send_back = (email_matches(param) + first_name_matches(param) + last_name_matches(param)).uniq
    return nil unless to_send_back

    to_send_back
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end

  def self.matches(field_name, param)
    where("#{field_name} LIKE ?", "%#{param}%")
  end

  def friend_already_followed?(friend_id)
    friends.where(id: friend_id).exists?
  end

  def except_current_user(users)
    users.reject { |user| user.id == id }
  end
end
