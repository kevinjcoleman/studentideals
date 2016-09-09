class AddEmailTelephoneWebsiteSidEditorialToBusinesses < ActiveRecord::Migration
  def change
    add_column :businesses, :telephone, :string
    add_column :businesses, :website, :string
    add_column :businesses, :email, :string
    add_column :businesses, :sid_editorial, :text
  end
end
