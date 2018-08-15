class Movie < ApplicationRecord
	include Elasticsearch::Model

	has_many :roles
	has_many :crews, through: :roles

	# we prefer the use of our own callbacks to be used when
	# saving-updating-deleting records
	# include Elasticsearch::Model::Callbacks

	# The Rails doc says that after_commit is triggered after BD transaction is finished
	# "They are most useful when your active record models need to interact 
	# with external systems which are not part of the database transaction"
	# just this case - update elasticsearch indexes after record transaction is finished
	after_commit :index_document, on: [:create, :update]
	after_commit :delete_document, on: [:destroy]

	def index_document
		IndexerJob.perform_later('index', self.id)
	end

	def delete_document
		IndexerJob.perform_later('delete', self.id)
	end

	has_and_belongs_to_many :genres

	mapping do 
	  indexes :id
	  indexes :name
	  indexes :description

	  indexes :crews, type: 'nested' do
	  	indexes :id, type: 'integer'
	  	indexes :name#, type: 'text', index: :not_analyzed
	  end

	  indexes :genres do
	  	indexes :id
	  	indexes :name
	  end
	end

	def as_indexed_json(options = {})
	  self.as_json(only: [:name, :description],
	  include: {
	  	genres: { only: [:id, :name]},
	  	crews: { only: [:id, :name]}
	  })
	end

	class << self

		def custom_search(query)
		__elasticsearch__.search(query: multi_match_query(query), aggs: aggregations)		
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

		def aggregations
			{
				crew_aggregation:
				{
					nested: {path: "crews"},
					aggs: crew_aggregation
				}
			}
		end

		def crew_aggregation
			{ id_and_name:
				{
					terms: { script: "doc['crews.id'].value + '|' + doc['crews.name'].value", size: 3}
				}
			}
		end
	end

end