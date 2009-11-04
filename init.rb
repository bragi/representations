require 'view_helpers'
require 'representations'
ActionView::Base.send :include, Representations::ViewHelpers
