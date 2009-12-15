module Representations
  class Representation
    attr_accessor :namespace
    #value - object for which the representation is created 
    #template - template view (needed because some ActionView::Base methods are private)
    #name - the actuall name of the method that was called on the object's parent that is being initialize
    #parent - Representation object which contains the object that is being initialize
    #namespace - allows to determine required namespace - useful for forms
    def initialize(value, template, name, parent=nil, namespace=nil)
      @value = value
      @name = name
      @template = template
      @parent = parent
      @namespace = namespace

      #extend class if user provided appropriate file (look at the files app/representations/*_representation.rb)
      #first check if file exists in app/representations
      file_name = "#{RAILS_ROOT}/app/representations/#{send(:class).to_s.demodulize.tableize.singularize}.rb"
      if File.exist?(file_name)
        ActiveSupport::Dependencies.require_or_load(file_name)
        Rails.logger.info "Extending Representation ::#{self.class.to_s.demodulize}"
        self.class.send(:include, "::#{self.class.to_s.demodulize}".constantize)
      end
      #extend this object's class if user provided per-model extensions (i.e. for Job model look at app/representations/job_representation.rb)
      file_name = "#{RAILS_ROOT}/app/representations/#{value.class.to_s.demodulize.tableize.singularize}_representation.rb"
      if File.exist?(file_name)
        ActiveSupport::Dependencies.require_or_load(file_name)
        Rails.logger.info "Extending Representation ::#{self.class.to_s.demodulize} for model #{value.class.to_s}"
        send(:extend, "::#{value.class.to_s}Representation".constantize) 
      end
    end
    def +(arg)
      to_s + arg.to_s
    end
    def to_param
      @value.id.to_s if @value
    end
    #returns escaped string from the object's to_s method
    def to_s
      @value ? ERB::Util::h(@value.to_s) : ''
    end
    #build or modify @namespace for Representation object 
    def current_namespace(passed_namespace = nil)
      if passed_namespace
        @namespace = "/" << passed_namespace.to_s << @template.polymorphic_path(@value)
      else
        @namespace = @template.polymorphic_path(@value)
      end
      @namespace
    end
    #returns html label tag for the representation
    def label(value = nil, html_options = {})
      tree = get_parents_tree
      for_attr_value = tree.collect{ |x| x[0] }.join('_')
      tags = get_tags(html_options, {:for => for_attr_value})
      value = ERB::Util::h(@name.humanize) if value.nil?
      %Q{<label #{tags}>#{value}</label>}
    end
    protected
    #Call the passed block (if any) 
    def with_block(&block)
      yield self if block_given? && @value
    end
    #Returns two dimensional array based on the tree of the Represantation objects which are linked together by the @parent field
    #First element of the array consists of Representation's @name and the second of Representation's class
    def get_parents_tree
      tree = Array.new
      tree[0] = []
      tree[0][0] = @name
      tree[0][1] = self.class
      parent = @parent
      while parent do #iterate parent tree
        array = []
        array[0] = parent.instance_variable_get(:@name)
        array[1] = parent.class
        tree.unshift(array)
        parent = parent.instance_variable_get(:@parent)
      end
      tree #tree now looks something like this [['user', ActiverRecordRepresentation], ['nick', DefaultRepresentation]]
    end
    #Creates value of the html name attribute according to the passed tree 
    def get_html_name_attribute_value(tree)
      first = tree.delete_at(0)
      root_name = first[0]
      name = []
      prev = nil
      tree.each do |elem| 
        if elem[1] == DefaultRepresentation || elem[1] == TimeWithZoneRepresentation || prev == AssociationsRepresentation
          name.push "[" + elem[0] + "]"
        else
          name.push "[" + elem[0] + "_attributes]"
        end
        prev = elem[1]
      end
      name.unshift(root_name)
    end
    #Returns string created by merging two hashes of html options passed as the arguments
    def get_tags(user_options, base_options)
      options = base_options.merge(user_options)
      options.stringify_keys!
      options = options.sort
      options.map{ |key, value| %(#{key}="#{value}" ) }
    end
    #If the wrapped object is nil return self to avoid invoking methods on nil object (if any will occur)
    def method_missing(method_name)
      @value ? super : self
    end
  end
end
