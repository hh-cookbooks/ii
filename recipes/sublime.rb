#package 'eclipse-platform'

execute 'add-apt-repository ppa:webupd8team/sublime-text-2 -y' do
  not_if {::File.exists? '/etc/apt/sources.list.d/webupd8team-sublime-text-2-precise.list'}
end

execute 'apt-get update' do
  action :nothing
  subscribes(:run,
    resources(:execute => "add-apt-repository ppa:webupd8team/sublime-text-2 -y"),
    :immediately)
end

package 'sublime-text' # sublime-text-2-beta, sublime-text-2-dev, sublime-text-dev

