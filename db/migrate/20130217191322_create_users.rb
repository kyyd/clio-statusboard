class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :display_name
      t.string :email
      t.string :password_digest
      t.string :status
      t.string :remember_token

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index  :users, :remember_token
  end
end
