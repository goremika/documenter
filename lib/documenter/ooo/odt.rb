require File.dirname(__FILE__)+'/odf.rb'
require 'hpricot'

class OdtText 
  attr_accessor :xml
  
  def initialize xml
		@xml = Hpricot.parse(xml)
	end

  def fill_form  data 
		(@xml/'text:user-field-decl').each do |decl|
			name = decl['text:name']
			decl['office:string-value']  = data[name] if data[name]
		end
		@xml
	end
	
	def replace_form data
		(@xml/'text:user-field-get').each do |decl|
			name = decl['text:name']
			if data && data[name]
				parent_html = decl.parent.inner_html 
        decl.parent.inner_html = parent_html.gsub(/#{decl.to_html}/,"#{data[name].to_s}")
			end
		end
    puts @xml
		@xml
	end
		
		
	def  find_table name
	end
	
		
	def rename_table oldname, newname
	end
	
  def to_html
    @xml.to_html
  end
  
  def to_xml
    @xml.to_html
  end
  
  def fill_table params
    edit_table(params) do |row, content|
      row.replace_form content
      row
    end
  end
  
		
	def edit_table params
		@name = params[:name]
		@rows = params[:data]
		raise 'cannot edit table rows without datarows' if !@rows || @rows.size==0
		@start_row = (params[:no_header]) ? 0 : 1
    
    table = nil
		@xml.search("table:table").each {|t| table = t if t['table:name'] == @name }
    raise "no such table '#{@name.to_s}'" if !table
    
    table['table:name'] = params[:new_name] if params[:new_name]
    puts table
    row =  (table/'table:table-row')[@start_row]
		template = row.to_html
		row.inner_html=''
    
		@rows.each do |row|
      puts 'inside'
      table.inner_html += (yield OdtText.new(template), row).to_html
		end
    
    #puts @xml
  end
	

	
end

class OdtFile < OdfFile
  attr_accessor :text
  
  def initialize filename
    super filename
    load
  end
  
  
  def load
    @text = OdtText.new(load_xml)
  end
  
  def save_changes
    save_xml @text.to_xml
  end
  
  
  def save filename
    save_changes
    super filename
  end
  
end


=begin


 posts = [{'posts' => 'asdasdasd'}, {'posts' => 'adfasdfasdf'}, {'posts' => 'asdfasf'}]
 packets = [{'t' => 'qweerty'}, {'t' => 'qwerty'}]
  
i =0 
	doc = OdtFile.new 'custom_register.odt'
  doc.text.fill_form('number' => 'test')
  doc.text.edit_table(:name => 'posts', :data =>posts) do |row, content|
    row.replace_form(content)
    row.edit_table(:name => 'packets', :new_name => 'packets'+i.to_s, :data => packets) do  |row2,content|
      row2.replace_form(content)
      i += 1
      row2
    end
    row
	end
	
	doc.save  'out.odt'
	doc.close


=end