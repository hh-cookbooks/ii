#
# Cookbook Name:: sputnik
# Recipe:: default
#
# Copyright 2012, Chris McClimans
#

include_recipe 'sputnik::repo'
include_recipe 'sputnik::_repo_gpg'

node.sputnik.profiles.each do |pname, profile|
  log "creating metapackage sputnik-profile-#{pname}:#{profile['packages']}"

  sputnik_metapackage "sputnik-profile-#{pname}" do
    depends profile['packages']
  end
  
end

log "creating updating local repository at #{node.sputnik.repodir}"
execute "#{node.sputnik.repodir}/update_release_signature"
execute "apt-get update"

node.sputnik.profiles.each do |pname, profile|
  log "installing sputnik-profile-#{pname}"
  package "sputnik-profile-#{pname}" do
    action :nothing # we won't instnall yet, go look it aptitude
  end
end

# notifies :run, resources(:execute => "#{node.sputnik.repodir}/update_release_signature")
# notifies :install, resources(:package => "sputnik-profile-#{pname}")

