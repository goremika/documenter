class Pdf
  
  def self.is_windows?
    processor, platform, *rest = RUBY_PLATFORM.split("-")
    platform == 'mswin32'
  end

  
  def self.join array_of_pdfs, output, extras = 'compress'
    if is_windows?
      system("pdftk/pdftk.exe #{array_of_pdfs*' '} cat output #{output} #{extras} dont_ask ")
    else
      raise "Currently only windows supported"
    end
  end
end
