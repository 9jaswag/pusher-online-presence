class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validates :is_signed_in, inclusion: [true, false]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  after_create :notify_pusher

  def notify_pusher
    Pusher.trigger('activity', 'login', self.as_json)
  end

  def as_json(options={})
    super(
      only: [:id, :email, :username]
    )
  end
end
