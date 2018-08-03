class Movie < ApplicationRecord
	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

	has_and_belongs_to_many :genres

end
