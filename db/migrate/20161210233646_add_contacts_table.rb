class AddContactsTable < ActiveRecord::Migration[5.0]
  def change
    
    create_table :contacts do |t|

      # t.belongs_to :team  #, dependent: :destroy
      t.integer   :team_id
      t.string    :name
      t.string    :gender
      t.string    :title
      t.string    :email
      t.integer   :phone
      t.datetime  :timestamp

    end
    
  end
end
