# frozen_string_literal: true

class SearchBuilder < Blacklight::SearchBuilder
  include Blacklight::Solr::SearchBuilderBehavior

  self.default_processor_chain += [:return_all_for_empty_query]

  def return_all_for_empty_query(solr_parameters)
    solr_parameters[:q] = '*:*' if solr_parameters[:q].blank?
  end
end
