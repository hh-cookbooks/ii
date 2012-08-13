# This should look thru the keys of node.ii.desktop as schemas, the values being a hash of settings and values

node.ii.desktop.each do |schema_name,settings|
  settings.each do |setting_name,setting_value|
    desktop_settings setting_name do
      schema schema_name
      value setting_value
      user node.ii.user
    end
  end
end
