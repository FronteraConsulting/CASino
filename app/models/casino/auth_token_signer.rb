require 'openssl'

module CASino
  class AuthTokenSigner < ActiveRecord::Base

    def public_key
      OpenSSL::PKey::RSA.new(public_key_pem_content)
    end

    def signature_valid?(signature, token)
      digest = OpenSSL::Digest::SHA256.new
      public_key.verify(digest, signature, token)
    end
    
  end
end
