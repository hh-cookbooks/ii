require 'etc'
include_recipe 'ruby::1.9.1' # needed to give us a system ruby that we can install veewee into 8)

package 'virtualbox'
package 'default-jre-headless' # needed to create the Autounattend.xml floppy
package 'ruby-bundler'
package 'rubygems'

# Ruby 1.9 by default, calling the package 1.9.1 is silly, it actually installs 1.9.3p0
execute 'echo ruby manual /usr/bin/ruby1.9.1 | update-alternatives --set-selections' do
  not_if 'update-alternatives --get-selections | grep ruby1.9.1'
end

gem_package 'veewee' do
  gem_binary '/usr/bin/gem'
end

iiuser=Etc.getpwnam(node.ii.user)

desktop = File.join(iiuser.dir,'Desktop')

vagrant_basebox = "#{node.hostname}-vbox-win7"
definition_dir = File.join(iiuser.dir,'VirtualBox VMs','definitions',vagrant_basebox)
# recursive ownership isn't easy with the directory resource
execute "mkdir -p '#{definition_dir}/iso'" do
  user iiuser.name
  not_if { ::File.exist? definition_dir }
end

['Autounattend.xml','definition.rb','install-cygwin-sshd.bat','postinstall.sh'].each do |vdef_file|
  template "#{definition_dir}/#{vdef_file}" do
    source "win7-virtual/#{vdef_file}.erb"
    owner iiuser.name
    group Etc.getgrgid(iiuser.gid).name
    variables ({
      :iiuser => iiuser,
      :computer_name => vagrant_basebox,
      :time_zone => 'Pacific Standard Time'
    })
  end
end

['install-winrm.bat','oracle-cert.cer'].each do |vdef_file|
  cookbook_file "#{definition_dir}/#{vdef_file}" do
    source "win7-virtual/#{vdef_file}"
    owner iiuser.name
    group Etc.getgrgid(iiuser.gid).name
  end
end

['client.rb','validation.pem'].each do |chef_vdef_file|
  file "#{definition_dir}/#{chef_vdef_file}" do
    content open("/etc/chef/#{chef_vdef_file}").read
    owner iiuser.name
    group Etc.getgrgid(iiuser.gid).name
  end
end

# remote_file "#{definition_dir}/iso/7600.16385.090713-1255_x64fre_enterprise_en-us_EVAL_Eval_Enterprise-GRMCENXEVAL_EN_DVD.iso" do
#   source "http://wb.dlservice.microsoft.com/dl/download/release/Win7/3/b/a/3bac7d87-8ad2-4b7a-87b3-def36aee35fa/7600.16385.090713-1255_x64fre_enterprise_en-us_EVAL_Eval_Enterprise-GRMCENXEVAL_EN_DVD.iso"
#   checksum '2c16c73388a5c02a0ec4cd8b9e5c14ba28b7b45d13d0c9c7d44459feecc0385f'
# end

template "#{desktop}/build-#{vagrant_basebox}.desktop" do
  source "build-win7-virtual.desktop.erb"
  owner iiuser.name
  group Etc.getgrgid(iiuser.gid).name
  variables ({
      :base_dir => File.join(iiuser.dir,'VirtualBox VMs'),
      :computer_name => "#{iiuser.name}+vwin7"
    })
  mode '0755'
end


# put together a definitions/*
#vagrant basebox build *

# execute 'tar xvfz /tmp/android-sdk_r20-linux.tgz' do
#   cwd '/usr/local'
#   not_if {::File.exists? '/usr/local/android-sdk-linux'}
# end
