Description
===========

This is a base cookbook for applying sputik developer profiles and
repositiories onto a Ubuntu 12.04 system.


The default recipe loops through the profile under the:
sputnik.profiles attribute

They can be set via the normal methods, I included two recipes to demonstrate.

The sputnik::from_yaml recipe loops through yaml files in the /etc/sputnik/profiles.

The sputnik::hippiehacker recipe sets a few like this:

```
node.set['sputnik']['profiles']['chris-virt']['packages'] = [
  'virtinst',
  'virt-manager',
  'virt-viewer',
  'virtualbox',
  'virtualbox-guest-additions-iso'
]
```

The attributes can/will be extended with support for

* An optional list of package-repositories or ppas.
* An optional list of debconf preseeded configuration responses.


Logic
=====

The default recipe will loop through all the sputink profiles
and create metapackages that depend on the listed packages.
The metapackages are of the form sputnik-#{id}, ie sputnik-my-profile.

A local repo will be created (in /var/lib/sputnik-repo by default), and a gpg
key will be created for root to sign packages and the repository.

This local repo is added to /etc/apt/sources.list.d, making the sputnik metpackages within it available.

At this point you can use aptitude, synaptic, apt-get to install the profiles you want,
and 'apt-get autoremove sputnick-profile-name' will remove the metapackage and all it's dependencies automatically.

We may want to automatically and and remove the profiles completely within the recipe, but I'm not doing that yet.

ie: at the end of the recipe, any sputnik-* metapackages that are not enabled are removed.

https://help.ubuntu.com/community/MetaPackages


Requirements
============

Ubuntu

Attributes
==========

```
['sputnik']['repodir'] = '/var/lib/sputnik'
```

The location of the local repository.

```
['sputnik']['maintainer'] = 'Sputnik Local <sputnik@localhost>'
```

The name of the gpg signing key to create packages and sign our local repo with.

```
['sputnik']['profiles']
```

No defaults, but must be populated with profiles. Look at sputnik::hippiehacker and sputnik::from_yaml_example for more details.

Usage
=====

### This recipe automatically copies the examples yaml templates into /etc/sputnik, then processes them

```
chef-solo -o sputnik::from_yaml_example
```

### This is the examples of a recipe that sets up the profile attributes directly

```
chef-solo -o sputnik::hippiehacker
```

### You could easily just run the default recipe and feed it your own json file attributes

```
chef-solo -o sputnik -j dna/my-dna.json
```

