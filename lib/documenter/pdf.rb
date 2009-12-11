require 'ftools'


class Pdf
  # pass to localy installed pdftk
  @@exe = File.dirname(__FILE__)+'/pdftk/pdftk.exe'
  
  #join array of pdfs filenames to one output file
  def self.cat pdfs, output
    system("#{@@exe} #{pdfs*' '} cat output #{output} compress dont_ask ")
  end
  
  #cut file to single pages
  def self.burst file, pattern
    system("#{@@exe} #{file} burst")
    Dir.new(".").each do |file|
      if (file =~ /pg_[0-9]*\.pdf/)
        number = file.match(/[0-9]{4}/)[0].to_i
        new_file = pattern % number
        File.move  file, new_file
      end
    end
  end
end