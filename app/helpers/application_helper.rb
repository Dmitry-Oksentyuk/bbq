module ApplicationHelper

  # возвращает путь к аватарке данного юзера
  def user_avatar(user)
  #   TODO: user real avatars
    asset_path('user.png')
  end

  def fa_icon(icon_class)
    content_tag 'span', '', class: "fa fa-#{icon_class}"
  end

  #метод склонятор, выводит существительные в нужном падеже
  def sklonyator(number, krokodil, krokodila, krokodilov)
    if number == nil || !number.is_a?(Numeric)
      number = 0
    end

    ostatok = number % 10
    ostatok_2 = number % 100

    if ostatok_2 >= 11 && ostatok_2 <= 14
      return krokodilov
    elsif ostatok == 1
      return krokodil
    elsif ostatok >= 2 && ostatok <= 4
      return krokodila
    elsif ostatok == 0 ||ostatok > 4
      return krokodilov
    end
  end

end
