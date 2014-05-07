class ChangeTypeToKindForShips < ActiveRecord::Migration
  def change
    rename_column :ships, :type, :kind
  end
end
