require "spec_helper"

describe Jsongram::ToJson do
  
  let(:sub_jsonified_class) { SubTestJsongram1 }
  
  describe ".to_json" do
    
    before(:each) do
      
      class TestJsongram1
        
        extend Jsongram
        
        is_jsonified do
          add_jsonified_attr :test1
        end
        
      end
      
      class SubTestJsongram1 < TestJsongram1
        
      end
      
    end
    
    let(:base_obj) { obj = Object.new; def obj.test1; "test1"; end; obj }
    
    #attribute was created with call: add_jsonified_attr :test1
    context "json attribute getter is empty/nil" do
      
      context "serializer does not have method" do
       let(:serializer) { sub_jsonified_class.new base_obj }
       it "gets value from base_obj calling method with the same name as attribute" do
          serializer.to_json.should eq Oj.dump({"test1" => "test1"})
        end
      end
      
      context "serializer has method" do
        let(:serializer) {
          ser = sub_jsonified_class.new base_obj
          def ser.test1; "test2"; end
          ser
        }
        
        it "gets value from serializer calling method with the same name as attribute if serializer have method" do
          serializer.to_json.should eq Oj.dump({"test1" => "test2"})
        end
      end
      
    end
    
    #attribute was created with call: add_jsonified_attr :test1, :test2
    context "json attribute getter is string or symbol" do
      
      before(:each) do
        class JsTest2 < TestJsongram
          add_jsonified_attr :test2, :test2
        end
        def base_obj.test2; "test2"; end
      end
      
      context "serializer does not have method" do
        let(:serializer) { JsTest2.new base_obj }
        it "gets value from base_obj calling method which was defined in getter parameter" do
          serializer.to_json.should eq Oj.dump({"test1" => "test1", "test2" => "test2"})
        end
      end
      
      context "serializer has method" do
        let(:serializer) {
          ser = JsTest2.new base_obj
          def ser.test2; "test3"; end
          ser
        }
        it "gets value from serializer calling method which was defined in getter parameter" do
          serializer.to_json.should eq Oj.dump({"test1" => "test1", "test2" => "test3"})
        end
      end
      
    end
    
    #attribute was created with call: add_jsonified_attr :test1, [1, 2]
    context "json attribute getter is enumerable" do
      
      context "no option was passed to add_jsonified_attr" do
        
        before(:each) do
          class JsTest3 < TestJsongram
            add_jsonified_attr :test3, [1, 2]
          end
        end
        
        let(:serializer) { JsTest3.new base_obj }
        it "iterates items and converts them to json with to_json" do
          serializer.to_json.should eq Oj.dump({"test1" => "test1", "test3" => ["1", "2"]})
        end
        
      end
      
      context "option :dont_iterate was passed to add_jsonified_attr" do
        
        before(:each) do
          class JsTest4 < TestJsongram
            add_jsonified_attr :test3, [1, 2], dont_iterate: true
          end
        end
        
        let(:serializer) { JsTest4.new base_obj }
        it "just converts to json" do
          serializer.to_json.should eq Oj.dump({"test1" => "test1", "test3" => [1, 2]})
        end
        
      end
      
    end
    
    #attribute was created with call: add_jsonified_attr :test1, -> {}#lambdaaaa
    context "json attribute getter is proc object" do
      before(:each) do
        class JsTest5 < TestJsongram
          add_jsonified_attr :test4, -> { base_obj.test1 }
        end
      end
      let(:serializer) { JsTest5.new base_obj }
      it "returns value from proc object exectuing it in serializer context" do
        serializer.to_json.should eq Oj.dump({"test1" => "test1", "test4" => "test1"})
      end
    end
    
  end
  
end