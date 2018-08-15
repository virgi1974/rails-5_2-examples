class IndexerJob < ActiveJob::Base
	queue_as :elasticsearch #custom name for this queue

	def perform(operation, record_id)
		self.send(operation, record_id)
	end

	private

	def index(record_id)
		record = Movie.find(record_id)
		record.__elasticsearch__.index_document
	end

	def delete(record_id)
		client = Movie.__elasticsearch__.client
		client.delete index: Movie_index_name, type: Movie.model_name.to_s.downcase, id: record_id
	end

end