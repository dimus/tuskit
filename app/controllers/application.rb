# A monkey patch to remove conversion by to_xml names like 'first_name' to 'first-name'
module ActiveSupport #:nodoc:
  module CoreExtensions #:nodoc:    
    module Hash #:nodoc:
      module Conversions
        #We force :dasherize to be false, since we never want it true.
        #Thanks very much to the reader on the flexiblerails Google Group who
        #suggested this better approach.
        unless method_defined? :old_to_xml
          alias_method :old_to_xml, :to_xml
          def to_xml(options = {})
            options.merge!(:dasherize => false)
            old_to_xml(options)
          end
        end
      end
    end
    module Array #:nodoc:
      module Conversions
        #We force :dasherize to be false, since we never want it true.
        unless method_defined? :old_to_xml
          alias_method :old_to_xml, :to_xml
          def to_xml(options = {})
            options.merge!(:dasherize => false)
            old_to_xml(options)
          end
        end
      end
    end
  end
end
module ActiveRecord #:nodoc:
  module Serialization
    #We force :dasherize to be false, since we never want it true.
    unless method_defined? :old_to_xml
      alias_method :old_to_xml, :to_xml
      def to_xml(options = {})
        options.merge!(:dasherize => false)
        old_to_xml(options)
      end
    end
  end
end
module ActiveRecord #:nodoc:
  class Errors #:nodoc:
    def to_xml_full(options={})
      options[:root] ||= "errors"
      options[:indent] ||= 2
      options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
      options[:builder].instruct! unless options.delete(:skip_instruct)
      options[:builder].errors do |e|
        #The @errors instance variable is a Hash inside the Errors class
        @errors.each_key do |attr|
          @errors[attr].each do |msg|
            next if msg.nil?
            if attr == "base"
              options[:builder].error("message"=>msg)
            else
              fullmsg = @base.class.human_attribute_name(attr) + " " + msg
              options[:builder].error("field"=>attr, "message"=>fullmsg)
            end
          end
        end
      end
    end  
  end
end

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require_dependency "task"
class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  before_filter :login_from_cookie
  before_filter :login_required
  before_filter :init
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_tuskit_session_id'

protected
  def init
    #can be implemented by controller
  end
end
