action :create do

  targetdir=::File.join(node.ii.repodir, "#{nr.name}-#{nr.version}")
  directory "#{targetdir}/debian" do
    recursive true
  end
  cookbook_file "#{targetdir}/debian/rules"
  cookbook_file "#{targetdir}/debian/compat"
  template "#{targetdir}/debian/control" do
    cookbook 'ii'
    source "control.erb"
    variables(
      :name => nr.name,
      :depends => nr.depends,
      :maintainer => node.ii.maintainer
    )
  end
  template "#{targetdir}/debian/changelog" do
    cookbook 'ii'
    source "changelog.erb"
    variables(
      :name => nr.name,
      :version => nr.version, 
      :maintainer => "#{node.ii.maintainer} <#{node.ii.maintainer_email}>"
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
  # execute "dput ppa:hippiehacker/ii ../#{nr.name}_#{nr.version}_source.changes" do
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
  #     :maintainer => node.ii.maintainer
  #   )
  # end
  # execute "equivs-build #{nr.name}" do
  #   cwd node.ii.output_dir
  # end
end

def nr # meta package
  @new_resource
end
