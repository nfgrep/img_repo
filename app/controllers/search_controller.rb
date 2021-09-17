class SearchController < ApplicationController
    def search
        if params[:query].blank?
          @results = []
        else
          @results = Elasticsearch::Model
                       .search(params[:query])
                       .results.as_json
                       .group_by { |result| result['_index'] }
        end
      end
end
