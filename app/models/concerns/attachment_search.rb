concern :AttachmentSearch do
  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings({
      analysis: {
        filter: {
          trigrams_filter: {
            type: 'ngram',
            min_gram: 3,
            max_gram: 3
          }
        },
        analyzer: {
          trigrams: {
            type: 'custom',
            tokenizer: 'standard',
            filter: ['lowercase', 'trigrams_filter']
          }
        }
      }
    }) do
      mappings _source: { excludes: ['file'] } do
        indexes :id, type: 'integer'
        indexes :title, analyzer: 'trigrams'
        indexes :filename, analyzer: 'trigrams'
        #   #   indexes :file_for_elasticsearch, type: 'attachment'
      end
    end
  end

  def file_for_elasticsearch
    file_base64
  end

  def file_base64
    path_to_file = self.file.file.file
    Base64.encode64(open(path_to_file) { |file| file.read })
  end

  def to_indexed_json
    to_json(methods: [:filename, :file_for_elasticsearch])
  end

  class_methods do
    def search(query)
      __elasticsearch__.search({
        query: {
          query_string: {
            query: query,
            fields: ['title', 'filename'],
            default_operator: 'AND',
            locale: 'de'
          }
          #multi_match: {
          #  query: query,
          #  fields: ['title', 'filename', 'file_for_elasticsearch']
          #}
        }
      }).records.records
    end
  end
end