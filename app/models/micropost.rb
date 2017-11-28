class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.maximum}
  validate  :picture_size
  scope :by_user, ->(id){where("user_id= ?", id)}
  scope :order_by_date, ->{order(created_at: :desc)}

  private

  def picture_size
    return unless picture.size > Settings.micropost.pic_size.megabytes
    errors.add :picture, t("controller.microposts.err_pic")
  end
end
