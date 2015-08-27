require 'spec_helper'

describe CASino::AuthTokenSigner do
  
  describe '#public_key' do
    it 'returns the public key from the pem content' do
      private_key = OpenSSL::PKey::RSA.new 4096
      auth_token_signer = FactoryGirl.build(:auth_token_signer, public_key_pem_content: private_key.public_key.to_pem)
      expect(auth_token_signer.public_key.to_pem).to eq(private_key.public_key.to_pem)
    end
  end

  describe '#signature_valid?' do
    it 'returns true if the signature is valid' do
      private_key = OpenSSL::PKey::RSA.new 4096
      auth_token_signer = FactoryGirl.build(:auth_token_signer, public_key_pem_content: private_key.public_key.to_pem)
      token = 'MY_TOKEN'
      digest = OpenSSL::Digest::SHA256.new
      signature = private_key.sign(digest, token)
      expect(auth_token_signer.signature_valid?(signature, token)).to be true
    end

    it 'returns false if the signature is not valid' do
      private_key = OpenSSL::PKey::RSA.new 4096
      auth_token_signer = FactoryGirl.build(:auth_token_signer, public_key_pem_content: private_key.public_key.to_pem)
      token = 'MY_TOKEN'
      digest = OpenSSL::Digest::SHA256.new
      signature = private_key.sign(digest, token)
      expect(auth_token_signer.signature_valid?(signature, 'BAD_TOKEN')).to be false
    end
  end

end
