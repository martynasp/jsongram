jsongram
========

Lite json serializer, only ruby and oj gem

Install
====

At the moment form github:

    gem "jsongram", git: "git://github.com/martynasp/jsongram.git"

Usage
====

    class MyJsongram
      extend Jsongram
    
      is_jsonified do
        add_jsonified_attr :id
        add_jsonified_attr :attribute
      end
    end

then use it:
    
    (MyJsongram.new some_obj).to_json

attributes are inherited only by subclasses:
    
    class MyJsongramChild < MyJsongram
      add_jsonified_attr :attribute2
    end

would have 3 attributes: :id, :attribute and :attribute2

add_jsonified_attr call:

    add_jsonified_attr :test

it will lookup for the method 'test' in jsonified class, if not found in base_obj,
in instance passed to initializer, json will get such attribute: {test: 'outcome of method test'}

add_jsonified_attr call:

    add_jsonified_attr :test, :some_method

it will lookup for the method 'some_method' in jsonified class, if not found - in base_obj,
in instance passed to initializer, json will get such attribute: {test: 'outcome of method some_method'}

You can pass proc/lambda to add_jsonified_attr:

    add_jsonified_attr :test, -> { base_obj.some_method }

it will call lambda/proc in context of base_obj, instance passed to initializer.
json will get such attribute: {test: 'outcome of { base_obj.some_method }'}

Refer to specs for other usages

TODO
====

Add caching support