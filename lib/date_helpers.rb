module DateHelpers

  def format_date(date,format='%m/%d/%y')
    date.strftime(format)
  end
  
  def dates_interval(date1, date2)
    raise ArgumentError, "#{format_date(date1)} is bigger than #{format_date(date2)}" if date1 > date2
    date_string = format_date(date1) + " - "
    if date1.year == date2.year
      date_string += format_date(date2, '%m/%d')
    else
      date_string += format_date(date2)
    end
    date_string  
  end
end
