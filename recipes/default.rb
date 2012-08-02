#
# Cookbook Name:: ii
# Recipe:: default
#
# Copyright 2012, Chris McClimans
#

include_recipe 'ii::repo'
include_recipe 'ii::_repo_gpg'

node.ii.profiles.each do |pname, profile|
  log "creating metapackage ii-profile-#{pname}:#{profile['packages']}"

  ii_metapackage "ii-profile-#{pname}" do
    depends profile['packages']
  end
  
end

log "creating updating local repository at #{node.ii.repodir}"
execute "#{node.ii.repodir}/update_release_signature"
execute "apt-get update"

node.ii.profiles.each do |pname, profile|
  log "installing ii-profile-#{pname}"
  package "ii-profile-#{pname}" do
    action :nothing # we won't instnall yet, go look it aptitude
  end
end

# notifies :run, resources(:execute => "#{node.ii.repodir}/update_release_signature")
# notifies :install, resources(:package => "ii-profile-#{pname}")

