require 'view_helpers'
require 'representations'
ActionView::Base.send :include, Representations::ViewHelpers
ActiveSupport::Dependencies.load_paths << "#{RAILS_ROOT}/app/representations/"
ActiveSupport::Dependencies.load_once_paths.delete "#{RAILS_ROOT}/app/representations/"
#Representations::DefualtRepresentation.send(:include, "::DefaultRepresentation".constantize) rescue Rails.logger.info "No AR extension defined for DefaultRepresentation"

