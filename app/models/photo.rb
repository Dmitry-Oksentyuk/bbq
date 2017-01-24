class Photo < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  # У фотографии всегда есть событие и пользователь
  validates :event, presence: true
  validates :user, presence: true

  # Добавляем аплоадер фотографий, чтобы заработал carrierwave
  mount_uploader :photo, PhotoUploader

end
