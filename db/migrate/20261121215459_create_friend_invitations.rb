class CreateFriendInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :friend_invitations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :email, null: false
      t.string :token_digest, null: false
      t.datetime :expires_at, null: false
      t.datetime :accepted_at

      t.timestamps
    end

    add_index :friend_invitations, :token_digest, unique: true

    add_index :friend_invitations,
              [ :user_id, :email ],
              unique: true

    add_index :friend_invitations, :expires_at
  end
end
