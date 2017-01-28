class AddAvatarVkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_vk, :string
  end
end
