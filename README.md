Description
===========


This is a base cookbook for applying ii developer profiles and
repositiories onto a Ubuntu 12.04 system.

Includes [a very simple recipe](https://github.com/hh-cookbooks/ii/blob/master/recipes/default.rb) that doesn't use any external attributes, yaml, json, etc to demonstrate simple usage of the [ii::default](https://github.com/hh-cookbooks/ii/blob/master/recipes/default.rb) recipe.

If you want to go the yaml route, check out the [ii::from_yaml_example](https://github.com/hh-cookbooks/ii/blob/master/recipes/from_yaml_example.rb) recipe, which will copy [all these files](https://github.com/hh-cookbooks/ii/tree/master/files/default/sputik_example_profiles) to /etc/ii and includes the [ii::from_yaml](https://github.com/hh-cookbooks/ii/blob/master/recipes/from_yaml.rb) recipe which processes /etc/ii/*yml (files can be copied in manually instead)

The result is a [local repo](https://github.com/ii/cookbook/blob/master/recipes/repo.rb) that contains our [MetaPackage}(https://help.ubuntu.com/community/MetaPackages) like profiles, though I've also [pushed profiles](https://github.com/hh-cookbooks/ii/blob/master/providers/metapackage.rb#L34) to my own ppa.

Dependent PPAs and debian-seeds via the yaml/attributes could be forthcoming.


Logic
=====

The default recipe will loop through all the sputink profiles
and create metapackages that depend on the listed packages.
The metapackages are of the form ii-#{id}, ie ii-my-profile.

A local repo will be created (in /var/lib/ii-repo by default), and a gpg
key will be created for root to sign packages and the repository.

This local repo is added to /etc/apt/sources.list.d, making the ii metpackages within it available.

At this point you can use aptitude, synaptic, apt-get to install the profiles you want,
and 'apt-get autoremove sputnick-profile-name' will remove the metapackage and all it's dependencies automatically.

We may want to automatically and and remove the profiles completely within the recipe, but I'm not doing that yet.

ie: at the end of the recipe, any ii-* metapackages that are not enabled are removed.

https://help.ubuntu.com/community/MetaPackages


Requirements
============

Ubuntu 12.04

Attributes
==========

```
['ii']['repodir'] = '/var/lib/ii'
```

The location of the local repository.

```
['ii']['maintainer'] = 'ii Local <ii@localhost>'
```

The name of the gpg signing key to create packages and sign our local repo with.

```
['ii']['profiles']
```

The default recipe loops through the profile under the ii.profiles attribute.

They can be set via the normal methods, I included two recipes to demonstrate.

The ii::from_yaml recipe loops through yaml files in the /etc/ii/profiles.

The ii::hippiehacker recipe sets a few like this:

```
node.set['ii']['profiles']['chris-virt']['packages'] = [
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


Usage
=====

### ii::from_yaml_example automatically copies the examples yaml templates into /etc/ii, then processes them

```
chef-solo -o ii::from_yaml_example
```

### ii::hippiehacker is an example of a recipe that sets up the profile attributes directly

```
chef-solo -o ii::hippiehacker
```

### You could easily just run the default recipe and feed it your own json file attributes, or use a role etc

```
chef-solo -o ii -j dna/my-dna.json
```

