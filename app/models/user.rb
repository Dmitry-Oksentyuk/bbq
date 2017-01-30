# (с) goodprogrammer.ru
#
# Модель Пользователя
class User < ActiveRecord::Base
  # добавляем к юзеру функции Девайза, перечисляем конкретные наборы функций
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:vkontakte]

  # юзер может создавать много событий
  has_many :events, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates_associated :subscriptions

  # имя юзера должно быть, и не длиннее 35 букв
  validates :name, presence: true, length: {maximum: 35}

  # при создании нового юзера (create), перед валидацией объекта выполнить метод set_name
  before_validation :set_name, on: :create

  after_commit :link_subscriptions, on: :create

  # Добавляем аплоадер аватарок, чтобы заработал carrierwave
  mount_uploader :avatar, AvatarUploader

  private

  # задаем юзеру случайное имя, если оно пустое
  def set_name
    self.name = "Товарисч №#{rand(777)}" if self.name.blank?
  end

  def link_subscriptions
    Subscription.where(user_id: nil, user_email: self.email).update_all(user_id: self.id)
  end

  def self.find_for_vkontakte_oauth(access_token)
    # Как выглядит объект access_token можно посмотреть на странице гема
    # https://github.com/mamantoha/omniauth-vkontakte#authentication-hash
    # Мы достаем из этого объекта url и provider, вместе они формируют
    # уникального пользователя
    url = access_token.info.urls.Vkontakte
    provider = access_token.provider

    # Ищем таких пользователей методом where, а методом
    # first_or_create! мы либо выбираем первого (если такой нашелся)
    # либо создаем нового с такими параметрами (url, provider),
    # к этому юзеру в случае создания также будет применен блок
    where(url: url, provider: provider).first_or_create! do |user|
      # В блоке мы прописываем пользователю имя, которое получили от ВКонтатке
      user.name = access_token.info.name
      # Формируем email из id пользователя ВКонтакте
      user.email = "#{access_token.uid}@vk.com"
      # И генерируем ему случайный надежный парроль
      # пользоваться им никто не будет, но формально по нему можно войти
      user.password = Devise.friendly_token[0,20]

      user.avatar_vk = access_token.info.image

      user.avatar_vk_lg = access_token.extra.raw_info.photo_big
    end
  end
end
