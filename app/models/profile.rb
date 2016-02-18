# == Schema Information
#
# Table name: profiles
#
#  id               :integer          not null, primary key
#  name             :string
#  profileable_id   :integer
#  profileable_type :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_profiles_on_name                                 (name)
#  index_profiles_on_profileable_type_and_profileable_id  (profileable_type,profileable_id)
#

class Profile < ActiveRecord::Base

	belongs_to :profileable, polymorphic: true

end
