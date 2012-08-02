#
# Cookbook Name:: ii
# Recipe:: from_yaml
#
# Copyright 2012, Chris McClimans
#

Dir.glob('/etc/ii/*yml').map do |yaml_file|
  p=YAML.load(open(yaml_file).read)
  #set['ii']['profiles'][p['name']]= {'packages'=>p['packages']}
  node.set['ii']['profiles'][p['name']]['packages']=p['packages']
end

include_recipe 'ii::default'
