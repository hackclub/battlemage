# == Schema Information
#
# Table name: user_identities
#
#  id                       :integer          not null, primary key
#  access_token_bidx        :string
#  access_token_ciphertext  :text
#  provider                 :string
#  refresh_token_bidx       :string
#  refresh_token_ciphertext :text
#  uid                      :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  user_id                  :integer          not null
#
# Indexes
#
#  index_user_identities_on_access_token_bidx     (access_token_bidx)
#  index_user_identities_on_provider_and_uid      (provider,uid) UNIQUE
#  index_user_identities_on_refresh_token_bidx    (refresh_token_bidx)
#  index_user_identities_on_user_id               (user_id)
#  index_user_identities_on_user_id_and_provider  (user_id,provider) UNIQUE
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class User::Identity < ApplicationRecord
    belongs_to :user
    has_encrypted :access_token, :refresh_token
    blind_index :access_token, :refresh_token, slow: true

    PROVIDERS = %w[slack hackatime idv].freeze

    validates :access_token, :provider, :uid, presence: true
    validates :provider, inclusion: { in: PROVIDERS }
    validates :uid, uniqueness: { scope: :provider }
    validates :provider, uniqueness: { scope: :user_id }
end
