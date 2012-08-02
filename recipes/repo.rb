file '/etc/apt/sources.list.d/ii-local.list' do
  content "deb file:#{node.ii.repodir} ./"
end

directory node.ii.repodir

cookbook_file "#{node.ii.repodir}/update_release_signature" do
  mode '755'
end

