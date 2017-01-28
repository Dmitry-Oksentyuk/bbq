class AddAvatarVkLgToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_vk_lg, :string
  end
end
