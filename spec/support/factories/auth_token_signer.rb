require 'factory_girl'

FactoryGirl.define do
  factory :auth_token_signer, class: CASino::AuthTokenSigner do
    name 'Test Auth Token Signer'
    enabled true
  end
end
