
class Csv
  #defaults params
  @@defaults = {:bracket => '"', :line_break => "\n", :cell_split => ',', :file => 'out.csv'}
  
    #save given params[:data] two demetions array to file
  def self.save params={}
    params = @@defaults.merge(params)
    File.open(params[:file],'w') do |f|
      f.write(params[:title]+params[:line_break]) if params[:title] 
      f.write array_to_str(params[:header],params)+params[:line_break] if params[:header] 
      params[:data].each do |row|
        #you can edit row in given block if you need so
        if block_given?
          ar = yield row
        else
          ar = row
        end
        f.write array_to_str(ar,params)+params[:line_break]
      end
    end
  end

  
  #converts one demention array to single csv string
  def self.array_to_str array, params
    params = @@defaults.merge params
    array.map{|x| params[:bracket]+x.to_s.gsub(/#{params[:bracket]}/,params[:bracket]+params[:bracket])+params[:bracket]}*params[:cell_split]
  end
  
  #load data from file into table
  def self.load_table file, params
    params = @@defaults.merge params
    bracket = params[:bracket]
    line_break = params[:line_break]
    cell_split = params[:cell_split]
    
    rows = []
    cells = []
    buffer = ''
    #bracket mode show if we between brackets. If so, we should not react on several things
    bracket_mode = false
    prev_bracket = false
    
    # we will look at one char at time
    file.each_byte do |byte|
      char =  byte.chr
      #if you see a bracket char
      if char == bracket
        #and previus was bracket to
        if prev_bracket==true
          #we just save one bracket
          buffer += char
          prev_bracket = false
        else
          prev_bracket = true
        end
        #after the bracket we change mode
        bracket_mode = !bracket_mode
      else
        prev_bracket = false
        if  !bracket_mode
          if char == cell_split || char == line_break
            #we met splitter
            #in sny way we finishing cell
            cells << buffer
            buffer = ''
            #but if it was a line break
            if char == line_break
              #we finish a line to 
              rows << cells
              cells = []
            end        
          else
            buffer += char        
          end
        else
          #in brackets mode we just copy data
          buffer += char        
        end
      end
    end
    #wen all data finished, we just save what we got in buffers
    cells << buffer if buffer.size>0
    rows << cells if cells.size>0
    rows
  end
end


class File
  #Easy loading data from file
  def csv params
    Csv.load_table(self, params)
  end
end

class String
  #Easy loading data from string
  def csv params
    Csv.load_table(self, params)
  end
end

class Array
  #saving data from array
  def to_csv params={}
    params[:data] = self
    #we can you block t change data defore saving
    if block_given?
      Csv.save(params) do |row|
        yield row
      end
    else
      Csv.save(params)
    end
  end
  
end

#data = File.open('test.csv').csv(:cell_split => ';')
#data.to_csv(:file => 'myout.csv', :header => ['a','a+100'], :cell_split => ';')

