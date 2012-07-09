file '/etc/apt/sources.list.d/sputnik-local.list' do
  content "deb file:#{node.sputnik.repodir} ./"
end

directory node.sputnik.repodir

cookbook_file "#{node.sputnik.repodir}/update_release_signature" do
  mode '755'
end

