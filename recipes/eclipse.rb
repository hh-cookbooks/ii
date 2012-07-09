package 'eclipse-platform'

bash 'temp fix for https://bugs.launchpad.net/ubuntu/+source/eclipse/+bug/989615' do
  code 'echo "-Djava.library.path=/usr/lib/jni" >> /etc/eclipse.ini'
  not_if 'grep /usr/lib/jni /etc/eclipse.ini'
end
