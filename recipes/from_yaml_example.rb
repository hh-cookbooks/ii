#
# Cookbook Name:: ii
# Recipe:: from_yaml_example
#
# Copyright 2012, Chris McClimans
#

# Some sillyness, to create copy an example .yml files into place BEFORE we
# include/compile in ii::from_yaml

remote_directory '/etc/ii' do
  source 'ii_example_profiles'
  action :nothing
end.run_action :create

include_recipe 'ii::from_yaml'
