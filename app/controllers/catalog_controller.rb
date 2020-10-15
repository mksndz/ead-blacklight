# frozen_string_literal: true

# Primary catalog actions and Blacklight configuration
class CatalogController < ApplicationController
  include Blacklight::Catalog

  configure_blacklight do |config|
    # Solr config
    config.default_solr_params = {
      rows: 10
    }
    config.document_solr_path = 'select'
    config.per_page = [10, 20, 50, 100]
    config.index.title_field = 'title_field'

    # solr field configuration for document/show views
    config.show.title_field = 'title_field'

    # Facets
    config.add_facet_fields_to_solr_request!
    config.add_facet_field 'name_facet', label: 'Subject', limit: true
    config.add_facet_field 'repository1_facet', label: 'Contributor', limit: true
    config.add_facet_field 'donor_facet', label: 'Donor', limit: true
    config.add_facet_field 'creator_facet', label: 'Creator', limit: true

    # Results
    config.add_index_field 'inclusive_date_field', label: 'Timespan'
    config.add_index_field 'repository1_field', label: 'Contributor'
    config.add_index_field 'abstract_scope_contents_field', label: 'Description'

    # Show
    config.add_show_field 'id', label: 'ID'
    config.add_show_field 'title_field', label: 'Title'
    config.add_show_field 'format', label: 'Format'
    config.add_show_field 'inclusive_date_field', label: 'Timespan'
    config.add_show_field 'repository1_field', label: 'Contributor'
    config.add_show_field 'name_field', label: 'Subjects'
    config.add_show_field 'abstract_scope_contents_field', label: 'Description'
    config.add_show_field 'xml', label: 'Raw EAD'

    # Fielded search configs
    config.add_search_field 'all_fields', label: 'All Fields'

    # Sort
    config.add_sort_field 'title', sort: 'title_sort asc', label: 'Title A-Z'
    config.add_sort_field 'date-added', sort: 'bulk_date_sort desc, title_sort asc', label: 'Recently Added'
    config.add_sort_field 'inclusive_date_sort', sort: 'inclusive_date_sort desc, title_sort asc', label: 'Year'

    # View Options
    config.add_results_document_tool(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)
    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)
    config.add_show_tools_partial(:bookmark, partial: 'bookmark_control', if: :render_bookmarks_control?)
    config.add_show_tools_partial(:email, callback: :email_action, validator: :validate_email_params)
    config.add_show_tools_partial(:sms, if: :render_sms_action?, callback: :sms_action, validator: :validate_sms_params)
    config.add_show_tools_partial(:citation)
    config.add_nav_action(:bookmark, partial: 'blacklight/nav/bookmark', if: :render_bookmarks_control?)
    config.add_nav_action(:search_history, partial: 'blacklight/nav/search_history')

    # Etc
    config.spell_max = 5
    config.autocomplete_enabled = false
  end
end
