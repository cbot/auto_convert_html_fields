require "auto_convert_html_fields/auto_convert_html_fields"

module AutoConvertHtmlFields
end

ActiveRecord::Base.send(:include, AutoConvertHtmlFields)