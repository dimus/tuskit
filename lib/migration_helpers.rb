module MigrationHelpers
  #creates foreign keys
  def foreign_key(from_table, from_column, to_table, cascade_delete=false)
    constraint_name = "fk_#{from_table}_#{from_column}" 
    cascade_delete ? on_delete = 'cascade' : on_delete = 'restrict' 
    execute %{alter table #{from_table}
              add constraint #{constraint_name}
              foreign key (#{from_column})
              references #{to_table}(id)
              on delete #{on_delete}
              on update restrict} rescue raise RuntimeError, "Foreign key from #{from_table}.#{from_column} to #{to_table}.id could not be created. Check that id and foreign key have the same data type"
  end
  
  
  #creates a fixture from database table information
  # Simple usage:
  # create_fixture :mytable, [:name]
  # More Advanced usage:
  # create_fixture :mytable, [:name], 100, 'id', 'id > 10'
  def create_fixture(from_table, title_fields = [:id], limit = nil, order_by = nil, conditions = nil)
    puts "Creating fixture #{from_table}.yml"
    file = RAILS_ROOT + "/test/fixtures/#{from_table}.yml"
    
    if not File.exists? file
      new_fixture = File.open(file, 'w')
      field_names = ActiveRecord::Base.connection.columns(from_table).map {|c| c.name.to_s} 
            
      set_conditions = '1 = 1'
      set_conditions = conditions if conditions
      
      set_limit = ''
      set_limit = "limit #{limit}" if limit
      
      set_order = ''
      set_order = "order by #{order_by}" if order_by
      yml_query = %{select *
      from #{from_table} 
      where #{set_conditions} #{set_order} #{set_limit} }
      p yml_query
      records = ActiveRecord::Base.connection.execute yml_query 
      record_count = 0
      records.each do |rec|
        p rec
        record_count += 1
        if limit and record_count >= limit
          break
        end
        if record_count % 100 == 0
          puts "Created #{record_count} records for #{from_table}.yml"
        end
        yml_string = ''
        title = {}
        title_fields.each do |e|
          title[e] = nil
        end
        count = 0
        rec.each do |field_val|
          field_name = field_names[count]
          if title_fields.find {|fld| fld == field_name.to_sym}
            title[field_name.to_sym] = field_val.to_s
          end
          yml_string += ' ' * 4 + field_name + ": " + field_val.to_s + "\n"
          count += 1
        end
        title_strings = []
        title_fields.each do |fld|
          title_strings << title[fld]
        end
        
        title_string = title_strings.join('_')
        title_string = title_string.gsub(' ','_').downcase
        title_string = title_string.gsub(/[^0-9a-z_]/,'')
        
        yml_string = title_string + ":\n" + yml_string
        new_fixture.write yml_string
      end
      new_fixture.close  
    else
      puts "File #{from_table}.yml aready exists"
    end
  end
end