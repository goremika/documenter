require 'digest/sha2'
require 'ftools'
require 'fileutils'

class Archive 
  def initialize folder
    @folder = folder
  end
  
  def self.file_key filename
    file_h = Digest::SHA2.new
    File.open(filename, 'r') do |fh|
      while buffer = fh.read(1024)
        file_h << buffer
      end
    end
    file_h
  end
  
  def self.hash_key hash
    Digest::SHA2.new << hash.to_yaml
  end
  
  def get_key params
    self.class.hash_key params
  end
  
  def has? params
    key  = get_key params
    File.exists? @folder+'/'+key.to_s
  end
  
  def put params, file
    key = get_key params
    File.copy @folder+'/'+file, key.to_s
  end
  
  def get params, file
    key = get_key params
    if File.exists? @folder+'/'+key.to_s
      File.copy @folder+'/'+key.to_s, file
    else
      raise 'No such file'
    end
  end
end

=begin 
arch = Archive.new '.'
template = Archive.file_key('text.txt')
data = {'a' => 'b'}
ar = Archive.new '.'
ar.put({:data => data, :template => template}, 'generated.txt')
#data['a']='a'
ar.get({:data => data, :template => template}, 'on.txt')
=end
