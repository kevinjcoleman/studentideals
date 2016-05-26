class AddAddressInfoToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :latitude, :float
    add_column :businesses, :longitude, :float
    add_column :businesses, :address1, :string
    add_column :businesses, :address2, :string
    add_column :businesses, :city, :string
    add_column :businesses, :state, :string
    add_column :businesses, :zip, :string
    add_column :businesses, :country_code, :string
  end
end
