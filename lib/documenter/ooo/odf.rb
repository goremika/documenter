require 'zip/zip'

class OdfFile
  
  def random_name 
		Time.now.strftime('%H%M%S')+rand(100000).to_s
	end
  
	def initialize filename
		#working with copy 
		rn = random_name
		@file = random_name+'tmp.odf'
		@content = random_name+'tmp.xml'
		
		File.copy filename, @file
		zip  = Zip::ZipFile.open(@file)
		zip.extract('content.xml',@content)	
	end
	
	def load_xml
		File.read(@content)
	end
	
	def save_xml xml
		File.open(@content,'w') do |f|
			f.write xml
		end
	end
	
	def close
		File.delete @content
		File.delete @file
	end
		
	def save filename
		zip  = Zip::ZipFile.open(@file) 
    puts "just before saving"
		zip.replace('content.xml',@content)
		zip.close
    File.copy @file, filename
	end
end
