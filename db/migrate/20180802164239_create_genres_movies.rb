class CreateGenresMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :genres_movies do |t|
    	t.integer :genre_id, index: true, unique: true
    	t.integer :movie_id, index: true
    end
  end
end

