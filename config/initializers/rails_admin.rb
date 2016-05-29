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
  config.main_app_name = "Student Ideals"

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
    object_label_method { :custom_biz_label }
    field :biz_id do
      label { 'SID Business ID' }
    end
    field :external_id do
      label { 'External ID' }
    end

    field :biz_name do
      label { 'Business Name' }
    end

    field :address1
    field :address2
    field :city
    field :state
    field :country_code
    field :longitude
    field :latitude
    field :sid_category do
      label { "Business Category"}
    end
    list do
      field :biz_id
      field :biz_name
      field :sid_category_id, :enum do
        label {"Business Category"}
        enum do
          SidCategory.pluck(:label, :id)
        end
        searchable :sid_category_id
      end

      field :state, :enum do
        enum { Business.pluck("DISTINCT state") }
      end

      exclude_fields :external_id, :address1, :address2, :city, :country_code, :longitude, :latitude, :sid_category
      scopes [nil, :without_sid_category]
    end
    import do
      mapping_key :biz_id
      field :biz_id do
        label { 'biz_id' }
      end
      field :external_id
      field :biz_name
      fields :sid_category_data
    end
  end

  config.model 'SidCategory' do
    label "Business Category" 
    label_plural "Business Categories"
    object_label_method { :custom_sid_label }
    field :sid_category_id do
      searchable true
      label {"SID Category ID"}
    end
    field :label do 
      sortable true
    end
    field :businesses
  end

  config.model 'Admin' do
    object_label_method { :name }
    field :email
    field :password
    field :password_confirmation
    field :last_sign_in_at
    list do 
      field :email
      exclude_fields :password, :password_confirmation 
    end
  end
end
