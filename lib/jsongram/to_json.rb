module Jsongram
  
  module ToJson
     
    require "oj"
    
    def initialize base_obj, options = {}
      @base_obj = base_obj
      @options = options
    end
     
    def base_obj
      @base_obj
    end
     
    def to_json
      Oj.dump hash_for_json
    end
     
    def hash_for_json
      res = {}
      self.class.jsonified_attributes.each do |key, description|
        res.merge! key.to_s => (get_json_attribute key, (description.fetch :getter), (description.fetch :options))
      end
      res
    end
     
    def get_json_attribute key, getter, options
      if getter == nil
        (respond_to? key) ? (send key) : (base_obj.send key)
        #string or symbol case, if methods is in jsonifier or base_obj delegate,
        #else just return getter - static value for this attribute
      elsif getter.is_a? String or getter.is_a? Symbol
        if respond_to? getter or base_obj.respond_to? getter
          (respond_to? getter) ? (send getter) : (base_obj.send getter)
        else
          getter.to_s
        end
        #if enumerator go through all of them and call to_json unless we should not do it
      elsif getter.is_a? Enumerable
        options[:dont_iterate] ? getter : (getter.map { |i| ((i.respond_to? :to_json) ? i.to_json : (Oj.dump i)) })
        #for proc/lambda execute it with self context
      elsif getter.respond_to? :call
        instance_exec &getter
      else
        getter
      end
    end
     
  end
  
end