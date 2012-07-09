#
# Cookbook Name:: sputnik
# Recipe:: from_yaml
#
# Copyright 2012, Chris McClimans
#

Dir.glob('/etc/sputnik/*yml').map do |yaml_file|
  p=YAML.load(open(yaml_file).read)
  #set['sputnik']['profiles'][p['name']]= {'packages'=>p['packages']}
  node.set['sputnik']['profiles'][p['name']]['packages']=p['packages']
end

include_recipe 'sputnik::default'
