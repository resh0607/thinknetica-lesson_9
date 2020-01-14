module Accessors
  def attr_accessors_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        value_history ||= []
        instance_variable_set(var_name, value)
        value_history << value
      end
    end
  end
end
