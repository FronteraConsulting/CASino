# This migration comes from casino (originally 20150827142603)
class CreateCASinoAuthTokenSigners < ActiveRecord::Migration
  def change
    create_table :casino_auth_token_signers do |t|
      t.string :name, null: :false
      t.text :public_key_pem_content, null: false
      t.boolean :enabled, null: false, default: true

      t.timestamps null: false
    end
  end
end
