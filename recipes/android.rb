remote_file '/tmp/android-sdk_r20-linux.tgz' do
  source 'http://dl.google.com/android/android-sdk_r20-linux.tgz'
  checksum '58c0728fe75fd0ef6800bf70d3d030c16364272d5c018ccef38118e6a84cffdb'
end

execute 'tar xvfz /tmp/android-sdk_r20-linux.tgz' do
  cwd '/usr/local'
  not_if {::File.exists? '/usr/local/android-sdk-linux'}
end
