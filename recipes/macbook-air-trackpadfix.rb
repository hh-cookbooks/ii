# A fix based on:
# http://ubuntuforums.org/showthread.php?t=1952532
file '/etc/pm/sleep.d/99mouse-pad' do
  mode '0755'
  content <<EOF
#!/bin/bash
case $1 in
   hibernate)

       ;;
   suspend)

       ;;
   thaw)
       rmmod bcm5974; modprobe bcm5974
       ;;
   resume)
       rmmod bcm5974; modprobe bcm5974
       ;;
   *)
       ;;
esac
EOF
end
