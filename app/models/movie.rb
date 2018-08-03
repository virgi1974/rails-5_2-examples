class Movie < ApplicationRecord
	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

	has_and_belongs_to_many :genres

	mapping do 
	  indexes :id
	  indexes :name
	  indexes :description

	  indexes :genres do
	  	indexes :id
	  	indexes :name
	  end
	end

	def as_indexed_json(options = {})
	  self.as_json(only: [:name, :description],
	  include: {
	  	genres: { only: [:id, :name]}
	  })
	end

end