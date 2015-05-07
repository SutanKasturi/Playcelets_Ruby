class CreateGcmMigrations < ActiveRecord::Migration
  def change
    create_table :gcm_migrations do |t|

      t.timestamps
    end
  end
end
