require 'helper'

#some integration style tests :)
class TestDocumenter < Test::Unit::TestCase
  should "get to diff files and join then to one" do
    data = [['a0','b0'],['a1','b1']]
    data.to_csv(:file => 'myout.csv', :header => ['a','b'])
    Converter.convert 'myout.csv', 'test1.pdf'
    
  end
  
  should "fill form and save as pdf" do 
    doc = OdtFile.new 'test_data/custom_register.odt'
    data = [{'posts' => '123'}, {'posts' => 'abcd'}]
    doc.text.fill_table(:name => "posts", :data => data)
    doc.save 'out.pdf'
    doc.close
  end
  
    
end
