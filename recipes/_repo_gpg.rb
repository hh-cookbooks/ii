directory '/root/.gnupg' do
  mode 700
end

template '/root/.gnupg/sputnik.params' do
  source 'gpg.params.erb'
end

package 'rng-tools' #needed for random number generation for gpg key creation

execute "rngd -r /dev/urandom ; gpg --no-options --batch --no-default-keyring --keyring /etc/apt/trusted.gpg.d/sputnik-local.gpg --secret-keyring ~/.gnupg/secring.gpg --gen-key /root/.gnupg/sputnik.params ; gpg --import /etc/apt/trusted.gpg.d/sputnik-local.gpg" do
  not_if {::File.exist? '/etc/apt/trusted.gpg.d/sputnik-local.gpg'}
end
