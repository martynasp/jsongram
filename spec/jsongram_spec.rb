require "spec_helper"

describe Jsongram do
  
  before(:each) do
    
    class TestJsongram
      
      extend Jsongram
      
      is_jsonified do
        add_jsonified_attr :test1
      end
      
    end
    
    class SubTestJsongram < TestJsongram
      
    end
    
  end
  
  let(:jsonified_class) { TestJsongram }
  let(:sub_jsonified_class) { SubTestJsongram }
  
  it "should decorate class with needed methods" do
    (jsonified_class.respond_to? :is_jsonified).should be_true
    (jsonified_class.respond_to? :add_jsonified_attr).should be_true
    (jsonified_class.respond_to? :inherited).should be_true
  end
  
  describe "#is_jsonified" do
    
    it "creates needed class instance methods and include ToJson" do
      jsonified_class.should_receive(:include).with(Jsongram::ToJson)
      jsonified_class.is_jsonified
      (jsonified_class.respond_to? :jsonified_attributes).should be_true
      (jsonified_class.respond_to? :jsonified_options).should be_true
    end
    
    it "executes block and save attributes, subclasses attributes, does not alter parent attributes" do
      jsonified_class.instance_exec do
        is_jsonified do
          add_jsonified_attr :test1
        end
      end
      jsonified_class.jsonified_attributes.should eq ({"test1" => {getter: nil, options: {}}})
      sub_jsonified_class.jsonified_attributes.should eq ({"test1" => {getter: nil, options: {}}})
      sub_jsonified_class.instance_exec do
        add_jsonified_attr :test2
      end
      sub_jsonified_class.jsonified_attributes.should eq ({"test1" => {getter: nil, options: {}}, "test2" => {getter: nil, options: {}}})
      jsonified_class.jsonified_attributes.should eq ({"test1" => {getter: nil, options: {}}})
    end
    
  end
  
end