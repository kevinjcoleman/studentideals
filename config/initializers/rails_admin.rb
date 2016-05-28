RailsAdmin.config do |config|

  ### Popular gems integration
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    import

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.configure_with(:import) do |config|
    config.logging = true
    config.line_item_limit = 7000
  end

  config.model 'Business' do
    field :biz_id do
      label { 'SID Business ID' }
      searchable true
    end
    field :external_id do
      label { 'External ID' }
      searchable true
    end

    field :biz_name do
      label { 'Business Name' }
      searchable true
    end

    field :address1
    field :address2
    field :city
    field :state
    field :country_code
    field :longitude
    field :latitude

    import do
      mapping_key :biz_id
      fields :sid_category_data

      field :biz_id do
        label { 'biz_id' }
      end
      field :external_id
      field :biz_name
    end
  end

end
