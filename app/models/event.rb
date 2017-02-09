# (с) goodprogrammer.ru
#
# Модель события
class Event < ActiveRecord::Base
  # событие всегда принадлежит юзеру
  belongs_to :user

  # у события много комментариев и подписок
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  # у события много подписчиков (объекты User), через таблицу subscriptions, по ключу user_id
  has_many :subscribers, through: :subscriptions, source: :user

  has_many :photos


  # юзера не может не быть
  validates :user, presence: true

  # заголовок должен быть, и не длиннее 255 букв
  validates :title, presence: true, length: {maximum: 255}

  validates :address, presence: true
  validates :datetime, presence: true

  # Метод, который возвращает всех, кто пойдет на событие:
  # всех подписавшихся и организатора
  def visitors
    (subscribers + [user]).uniq
  end

  # совпадает ли переданный параметр с пинкодом этого события
  def pincode_valid?(pin2chek)
    pincode == pin2chek
  end
end

