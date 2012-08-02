#
# Cookbook Name:: ii
# Recipe:: chris
#
# Copyright 2012, Chris McClimans
#

# This is a set of example profiles with just packages

node.set['ii']['profiles']['chris-virt']['packages'] = [
  'virtinst',
  'virt-manager',
  'virt-viewer',
  'virtualbox',
  'virtualbox-guest-additions-iso'
]

node.set['ii']['profiles']['chris-emacs']['packages']= [
  'emacs',
  'emacs-goodies-el',
  'devscripts-el',
  'debian-el',
  'dpkg-dev-el',
  'git-el',
  'autocomplete-el',
  'emacs-jabber'
]

node.set['ii']['profiles']['chris-erlang']['packages']= [
  'sputnick-chris-emacs',
  'erlang'
]

node.set['ii']['profiles']['chris-android']['packages']= [
  'sputnick-chris-emacs',
  'eclipse'
]

include_recipe 'ii::default'
