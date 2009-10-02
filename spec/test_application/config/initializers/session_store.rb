# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_test_application_session',
  :secret      => '15c8961a156d62efa3a2338e240e3f8431a22274934fa558596f32b9c3d58ec1dd690b87dc18b5baa9672df518f07408869a87ec3cdb38cc10aff706c5af14e4'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
