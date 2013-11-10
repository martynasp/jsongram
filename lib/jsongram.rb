##
# light json generator using oj gem
module Jsongram

  require "jsongram/to_json"

  VERSION = [0,0,1]

  class << self
    # Return the version as a dotted string.
    def version
      VERSION.join(".")
    end
    
    # Return the release as a dotted string.
    def self.release
      "1.0"
    end
  end#end class methods
  
  def is_jsonified options = {}
    class << self
      attr_reader :jsonified_attributes, :jsonified_options
    end
    @jsonified_attributes = {}
    @jsonified_options = options
    include ToJson
    yield if block_given?
  end
   
  def add_jsonified_attr key, getter = nil, options = {}
    jsonified_attributes.merge! key.to_s => { getter: getter, options: options }
  end
   
  def inherited(subclass)
    subclass.instance_variable_set "@jsonified_attributes", jsonified_attributes.dup
  end
   
end