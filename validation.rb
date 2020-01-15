module Validation
  def validate(name, options = {})
    define_method(:validate!) do
      attr = instance_variable_get("@#{name}".to_sym)
      raise 'No attribute!' if options[:presence] && !attr
      raise 'Wrong attribute format!' if options[:format] && attr.to_s !~ options[:format]
      raise 'Wrong type!' if options[:type] && !attr.is_a?(options[:type])
      true
    end
  end

  define_method(:valid?) { validate! rescue false }
  
end