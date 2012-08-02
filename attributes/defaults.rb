require 'etc'
user = Etc.getpwuid(1001)
default['ii']['repodir'] = '/var/lib/ii'
default['ii']['maintainer'] = ':ii Local <ii@localhost>'
default['ii']['user'] = user.name
