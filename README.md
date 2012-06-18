Description
===========

This is a base cookbook for applying developer profiles and
repositiories onto a Ubuntu 12.04 system.

Sputnik developer profiles are json data-bag items which are usually
part of a developer dna repository.

Developer dna repositories are basically chef-repos set up for
chef-solo.


Developer profiles should go in the data_bags/profiles directory of
your sputnik-dna chef-repo and consist of:

* An id
* A list of package to install.
* An optional list of package-repositories or ppas.
* An optional list of debconf preseeded configuration responses.

data_bags/sputnik_profiles/rails+sublime.json:

```json

{
    "id": "rails+sublime",
    "packages": [
        "rails",
        "sublime-text-2-beta"
    ],
    "repos": [
        "ppa:webupd8team/sublime-text-2"
    ]
    "seed": {
        "railspackage/with_some/debconf_option": "someconfig item value"
    }
}

```

Metapackages will be created that depend on the listed packages.  The
metapackages are of the form sputnik-#{id}, ie sputnik-rails+sublime.
When the metapackages are removed, dependent packages are removed
unless required elsewhere.

https://help.ubuntu.com/community/MetaPackages





Sputnik profiles are usually applied by looking at the DNA of a Cosmonaut.

Cosmonaut DNA can be as simple as json file with list of sputnik profiles to apply.

They can go in the dna directory and also consist of:

* An optional run_list, which if present, must at least include the sputnick recipe 
* An optional sputnik_repo url, which points to a valid sputnik repo (git, etc)

dna/my-dna.json:

```json

{
    "sputnik_profiles" : {
        "rails+sublime",
        "rails+emacs"
    },
    "run_list": [ "recipe[sputnik]" ],
    "sputnik_repo" : {
        "git@github.com/hh/sputnik.git"
    }
}

```

The run_list is optional, but gives us room to extend beyond simple
profiles.

In the future, the sputnik_repo will allow us to hand out ONLY the dna
file to easily facilitating further customizations. This would be
cloned and used as the chef-repo containing the sputnik profiles and
possibly other recipes to be applied via the run_list.






The sputnik default cookbook loops through the sputnik_profiles in your dna.json:

* Enabling new repos via apt-add-repository ; apt-get update.
* Installing sputnick-* metapackages created from each profile.
* Removing unused sputnik metapackages that are no longer required.

Repositories do not have automatic dependencies and have to be handled a bit more carefully:

We will keep track of repositories we have added via sputnik, and which profiles depend
on them. The repos will only be removed if all profiles that include them have been removed.

We will eventually have to think about what should be done if a ppa or repo has
already been added manually in /etc/apt/sources.list.d or /etc/apt/sources.list.
But for now we will assume they are managed with sputnik.


Requirements
============

Ubuntu

Attributes
==========

Usage
=====

If hh.json doesn't include a run_list, override and force the sputnik::default recipe:

```
chef-solo -c config/sputnik.rb -j dna/my-dna.json -o sputnik
```

Otherwise use the included run_list, hoping it includes sputnik:

```
chef-solo -c config/sputnik.rb -j dna/my-dna.json 
```
