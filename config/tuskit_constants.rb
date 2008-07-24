XML_HEADER = '<?xml version="1.0" encoding="UTF-8" ?>'

ERRORS = {
  :foreign_key_problem => "Foreign Key Problem",
  :not_authorized => "Not Authorized"
} 

XML_ERRORS = {}
ERRORS.keys.each do |key|
  XML_ERRORS[key] = "#{XML_HEADER}<errors><error>#{ERRORS[key]}</error></errors>"
end

