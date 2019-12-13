class CreateUsersAndItems < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :email
      t.string :phone
      t.string :location
    end
    create_table :items do |t|
      t.string :title
      t.string :description
      t.integer :max_borrow_days
      t.integer :user_id
      t.integer :borrower_id
    end
  end
end
