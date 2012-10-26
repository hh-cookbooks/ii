require 'etc'
begin
  user = Etc.getpwuid(1001).name
rescue
  user = 'root'
end
default['ii']['repodir'] = '/var/lib/ii'
default['ii']['maintainer_email'] = 'ii@localhost'
default['ii']['maintainer'] = 'ii Local'
default['ii']['user'] = user
