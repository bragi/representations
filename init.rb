require 'view_helpers'
require 'representations'
ActionView::Base.send :include, Representations::ViewHelpers
ActiveSupport::Dependencies.load_paths << "#{RAILS_ROOT}/app/representations/"
