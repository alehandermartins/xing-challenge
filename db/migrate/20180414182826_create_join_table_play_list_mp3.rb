class CreateJoinTablePlayListMp3 < ActiveRecord::Migration[5.2]
  def change
    create_join_table :play_lists, :mp3s do |t|
      t.index [:play_list_id, :mp3_id]
    end
  end
end
