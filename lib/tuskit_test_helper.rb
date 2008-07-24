module TuskitTestHelper
  
  # Traverses recursively through a hash of hashes with arrays thrown in
  # and converts keys to symbols
  def keys_to_sym(obj)
    if obj then
      if obj.class == [].class then
        obj.each {|o| keys_to_sym(o) } 
      elsif obj.class == {}.class then
        obj.keys.each do |key|
          obj[key.to_sym] = obj[key]
          obj.delete(key)
          keys_to_sym(obj[key.to_sym])
        end
      end
     else
      obj
    end
  end
  
  def xml_to_params(xml_string, options)
    param_data = Hash.from_xml(xml_string)
    keys_to_sym(param_data)
    param_data_type = param_data.keys.first
    param_data = param_data.values.first.merge(options)
    return param_data_type, param_data
  end
    
end