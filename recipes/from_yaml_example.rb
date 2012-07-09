#
# Cookbook Name:: sputnik
# Recipe:: from_yaml_example
#
# Copyright 2012, Chris McClimans
#

# Some sillyness, to create copy an example .yml files into place BEFORE we
# include/compile in sputnik::from_yaml

remote_directory '/etc/sputnik' do
  source 'sputnik_example_profiles'
  action :nothing
end.run_action :create

include_recipe 'sputnik::from_yaml'
