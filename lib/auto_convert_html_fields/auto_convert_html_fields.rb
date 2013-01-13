module AutoConvertHtmlFields
	module AutoConvertHtmlFields
		extend ActiveSupport::Concern
		
		included do
		end
		
		module ClassMethods
	    	def auto_convert_html_fields(options = {})
				send :before_save, :convert_html_fields
				send :include, ActionView::Helpers::SanitizeHelper
				send :include, ActionView::Helpers::TextHelper
				
				cattr_accessor :achf_allowed_tags
				self.achf_allowed_tags = options[:allowed_tags] || {}
				
				cattr_accessor :achf_allowed_attributes
				self.achf_allowed_attributes = options[:allowed_attributes] || {}
				
				cattr_accessor :achf_convert_newlines
				self.achf_convert_newlines = options[:convert_newlines] || false
				
				cattr_accessor :achf_apply_simple_format
				self.achf_apply_simple_format = options[:apply_simple_format] || false

				unless options.include?(:dont_protect_html_fields)
					content_columns.each do |c|
						if self.column_names.include?("#{c.name}_html")
							send :attr_protected, "#{c.name}_html".to_sym
						end
					end
				end
			end
	  	end
	
		def convert_html_fields
			options = {}
			options[:tags] = self.class.achf_allowed_tags unless self.class.achf_allowed_tags.empty?
			options[:attributes] = self.class.achf_allowed_attributes unless self.class.achf_allowed_attributes.empty?
			self.class.content_columns.each do |c|
				if self.respond_to?("#{c.name}_html") && !self.send("#{c.name}").nil?
					if self.class.achf_convert_newlines
						self.send("#{c.name}_html=", sanitize(BBCodeizer.bbcodeize(self.send("#{c.name}")), options).gsub(/[\s\n\r]+\Z/,"").gsub("\n","<br />"))
					elsif self.class.achf_apply_simple_format
						self.send("#{c.name}_html=", simple_format(sanitize(BBCodeizer.bbcodeize(self.send("#{c.name}")), options).gsub(/[\s\n\r]+\Z/,""), {}, {:sanitize => false}))
					else
						self.send("#{c.name}_html=", sanitize(BBCodeizer.bbcodeize(self.send("#{c.name}")), options).gsub(/[\s\n\r]+\Z/,""))
					end
				end
			end
		end
	end
end

ActiveRecord::Base.send :include, AutoConvertHtmlFields::AutoConvertHtmlFields