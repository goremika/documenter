
class Converter
  @@initialized  = false
  def self.office_path
    'c:\Program Files\OpenOffice.org 3\program\soffice.exe'
    #todo - search for installed
    #todo - check for small portable version
  end
  
    
  
  def self.init
    ooo = office_path
    system('"'+ooo+' " -headless -accept="socket,port=8100;urp;"')  
    @@initialized = true
    #todo - check if already running
  end
  
  
  def self.convert from, to 
    init if !@@initialized 
    system("java -jar #{File.dirname(__FILE__)}/jod/lib/jodconverter-cli-2.2.2.jar #{from} #{to}")
  end
end

#Converter.convert 'test.csv', 'text.xls'


