directory '/root/.gnupg' do
  mode 700
end

template '/root/.gnupg/ii.params' do
  source 'gpg.params.erb'
end

package 'rng-tools' #needed for random number generation for gpg key creation

execute "rngd -r /dev/urandom ; gpg --no-options --batch --no-default-keyring --keyring /etc/apt/trusted.gpg.d/ii-local.gpg --secret-keyring ~/.gnupg/secring.gpg --gen-key /root/.gnupg/ii.params ; gpg --import /etc/apt/trusted.gpg.d/ii-local.gpg" do
  not_if {::File.exist? '/etc/apt/trusted.gpg.d/ii-local.gpg'}
end
