# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Youngagrarians::Application.config.secret_token = if Rails.env.development? || Rails.env.test?
  'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
else
  token_file = Rails.root.join( 'config/secrets/secret_token' )
  unless File.exist?( token_file )
    raise "Put a token in #{token_file}"
  end
  File.read( token_file )
end


Youngagrarians::Application.config.secret_key_base = if Rails.env.development? || Rails.env.test?
  'zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz'
else
  token_file = Rails.root.join( 'config/secrets/secret_key_base' )
  unless File.exist?( token_file )
    raise "Put a token in #{token_file}"
  end
  File.read( token_file )
end


