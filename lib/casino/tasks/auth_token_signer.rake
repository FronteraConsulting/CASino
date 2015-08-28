require 'io/console'

namespace :casino do
  namespace :auth_token_signer do

    namespace :add do

      desc 'Add Auth Token Signer from environment variable'
      task :env, [:name, :env_key] => :environment do |task, args|
        name = args[:name]
        env_key = args[:env_key]
        if !name.present?
          print 'Name of Auth Token Signer: '
          name = STDIN.gets.chomp
        end
        if !env_key.present?
          print 'Environment variable containing PEM content: '
          env_key = STDIN.gets.chomp
        end
        puts
        if name.present? && env_key.present?
          if ENV[env_key].present?
            auth_token_signer = CASino::AuthTokenSigner.create!(name: name, public_key_pem_content: ENV[env_key])
            puts "Created Auth Token Signer '#{auth_token_signer.name}' with ID #{auth_token_signer.id}."
          else
            puts "ERROR: There is no value for the environment variable '#{env_key}'."
          end
        else
          puts 'ERROR: Both Name of Auth Token Signer and Public Key PEM File are required.'
        end
        puts
      end

      desc 'Add Auth Token Signer from PEM file'
      task :file, [:name, :public_key_pem_file_path] => :environment do |task, args|
        name = args[:name]
        public_key_pem_file_path = args[:public_key_pem_file_path]
        if !name.present?
          print 'Name of Auth Token Signer: '
          name = STDIN.gets.chomp
        end
        if !public_key_pem_file_path.present?
          print 'Public Key PEM File: '
          public_key_pem_file_path = STDIN.gets.chomp
        end
        puts
        if name.present? && public_key_pem_file_path.present?
          auth_token_signer = CASino::AuthTokenSigner.create!(name: name, public_key_pem_content: File.read(public_key_pem_file_path))
          puts "Created Auth Token Signer '#{auth_token_signer.name}' with ID #{auth_token_signer.id}."
        else
          puts "ERROR: Both Name of Auth Token Signer and Public Key PEM File are required."
        end
        puts
      end

      desc 'Add Auth Token Signer from STDIN'
      task :stdin, [:name] => :environment do |task, args|
        name = args[:name]
        public_key_pem_content = STDIN.gets(nil)
        puts
        if name.present? && public_key_pem_content.present?
          auth_token_signer = CASino::AuthTokenSigner.create!(name: name, public_key_pem_content: public_key_pem_content)
          puts "Created Auth Token Signer '#{auth_token_signer.name}' with ID #{auth_token_signer.id}."
        else
          puts "ERROR: Both Name of Auth Token Signer and Public Key PEM Content are required."
        end
        puts
      end

    end

    desc 'Remove Auth Token Signer'
    task :remove, [:id] => :environment do |task, args|
      id = args[:id]
      if !id.present?
        has_records = false
        CASino::AuthTokenSigner.all.each do |auth_token_signer|
          puts "#{auth_token_signer.id}: #{auth_token_signer.name}"
          has_records = true
        end
        if has_records
          puts
          print 'Enter the ID of the Auth Token Signer to remove: '
          id = STDIN.gets.chomp
        else
          puts 'There are no Auth Token Signers to remove.'
        end
      end
      puts
      if id.present?
        deleted_count = CASino::AuthTokenSigner.delete(id)
        if deleted_count > 0
          puts "Deleted Auth Token Signer with ID #{id}."
        else
          puts "ERROR: Auth Token Signer with ID #{id} does not exist."
        end
      end
      puts
    end

    desc 'List Auth Token Signers'
    task :list => :environment do |task, args|
      has_records = false
      CASino::AuthTokenSigner.all.each do |auth_token_signer|
        puts "#{auth_token_signer.id}: #{auth_token_signer.name} (#{auth_token_signer.enabled ? 'enabled' : 'disabled'})"
        has_records = true
      end
      if !has_records
        puts 'There are no Auth Token Signers to remove.'
      end
      puts
    end

    desc 'Enable Auth Token Signer'
    task :enable, [:id] => :environment do |task, args|
      id = args[:id]
      if !id.present?
        has_records = false
        CASino::AuthTokenSigner.where(enabled: false).each do |auth_token_signer|
          puts "#{auth_token_signer.id}: #{auth_token_signer.name}"
          has_records = true
        end
        if has_records
          puts
          print 'Enter the ID of the Auth Token Signer to enable: '
          id = STDIN.gets.chomp
        else
          puts 'There are no Auth Token Signers to enable.'
        end
      end
      puts
      if id.present?
        if CASino::AuthTokenSigner.find(id).update(enabled: true)
          puts "Auth Token Signer with ID #{id} has been enabled."
        end
      else
        puts 'ERROR: ID is required.'
      end
      puts
    end

    desc 'Disable Auth Token Signer'
    task :disable, [:id] => :environment do |task, args|
      id = args[:id]
      if !id.present?
        has_records = false
        CASino::AuthTokenSigner.where(enabled: true).each do |auth_token_signer|
          puts "#{auth_token_signer.id}: #{auth_token_signer.name}"
          has_records = true
        end
        if has_records
          puts
          print 'Enter the ID of the Auth Token Signer to disable: '
          id = STDIN.gets.chomp
        else
          puts 'There are no Auth Token Signers to disable.'
        end
      end
      puts
      if id.present?
        if CASino::AuthTokenSigner.find(id).update(enabled: false)
          puts "Auth Token Signer with ID #{id} has been disabled."
        end
      else
        puts 'ERROR: ID is required.'
      end
      puts
    end

  end
end