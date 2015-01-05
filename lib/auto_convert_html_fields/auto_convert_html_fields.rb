module AutoConvertHtmlFields
	
	def self.included(base)
		base.extend(ActionView::Helpers::SanitizeHelper::ClassMethods)
		base.send(:include, ActionView::Helpers::SanitizeHelper)
		base.send :extend, ClassMethods
	end

	module ClassMethods
		def auto_convert_html_fields(options = {})
			send :include, InstanceMethods
			send :before_save, :convert_html_fields

			options = {:allowed_tags => {}, :allowed_attributes => {}, :convert_newlines => false}.merge(options)

			cattr_accessor :achf_allowed_tags
			self.achf_allowed_tags = options[:allowed_tags]
			
			cattr_accessor :achf_allowed_attributes
			self.achf_allowed_attributes = options[:allowed_attributes]
			
			cattr_accessor :achf_convert_newlines
			self.achf_convert_newlines = options[:convert_newlines]
		end
	end

	module InstanceMethods
		include ActionView::Helpers::SanitizeHelper
		include AutoConvertHtmlFields::ClassMethods
		
		def convert_html_fields
			options = {}
			options[:tags] = self.class.achf_allowed_tags unless self.class.achf_allowed_tags.empty?
			options[:attributes] = self.class.achf_allowed_attributes unless self.class.achf_allowed_attributes.empty?
			self.class.content_columns.each do |c|
				if self.respond_to?("#{c.name}_html") && !self.send("#{c.name}").nil?
					if self.class.achf_convert_newlines
					    self.send("#{c.name}_html=", sanitize(self.send("#{c.name}"), options).gsub(/[\s\n\r]+\Z/,"").gsub("\n","<br />"))
					else
					    self.send("#{c.name}_html=", sanitize(self.send("#{c.name}"), options).gsub(/[\s\n\r]+\Z/,""))
					end
				end
			end
		end
	end
end