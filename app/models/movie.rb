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

	class << self

		def custom_search(query)
		__elasticsearch__.search(query: multi_match_query(query))		
		end

		def multi_match_query(query)
			{
				multi_match: {
					query: query,
					type: "best_fields", #other possible values "most_fields" "phrase" "phrase_prefix" "cross_fields"
					fields: ["name^9", "description^8", "genres.name^10"],
					operator: "and"
				}
			}
		end
	end

end