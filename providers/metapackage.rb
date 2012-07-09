action :create do

  targetdir=::File.join(node.sputnik.repodir, "#{nr.name}-#{nr.version}")
  directory "#{targetdir}/debian" do
    recursive true
  end
  cookbook_file "#{targetdir}/debian/rules"
  cookbook_file "#{targetdir}/debian/compat"
  template "#{targetdir}/debian/control" do
    cookbook 'sputnik'
    source "control.erb"
    variables(
      :name => nr.name,
      :depends => nr.depends,
      :maintainer => node.sputnik.maintainer
    )
  end
  template "#{targetdir}/debian/changelog" do
    cookbook 'sputnik'
    source "changelog.erb"
    variables(
      :name => nr.name,
      :version => nr.version, 
      :maintainer => node.sputnik.maintainer
    )
  end

  # make binary package
  execute "dpkg-buildpackage for #{nr.name}" do
    command "dpkg-buildpackage"
    cwd targetdir
  end

  # # make source package
  # execute "debuild source for #{nr.name}" do
  #   command "debuild -S -sd"
  #   cwd targetdir
  # end

  # # upload to ppa?
  # execute "dput ppa:hippiehacker/sputnik ../#{nr.name}_#{nr.version}_source.changes" do
  #   cwd targetdir
  # end

  # This sorta worked
  # but I didn't realize you could build source package for equivs until I found:
  # http://askubuntu.com/questions/33413/how-to-create-a-meta-package-that-automatically-installs-other-packages
  # package 'equivs'
  # template "#{targetdir}/#{nr.name}" do
  #   cookbook 'metapackage'
  #   source "equivs.erb"
  #   variables(
  #     :name => nr.name,
  #     :maintainer => node.sputnik.maintainer
  #   )
  # end
  # execute "equivs-build #{nr.name}" do
  #   cwd node.sputnik.output_dir
  # end
end

def nr # meta package
  @new_resource
end
