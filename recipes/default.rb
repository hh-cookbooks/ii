#
# Cookbook Name:: sputnik
# Recipe:: default
#
# Copyright 2012, Chris McClimans
#

include_recipe 'metapackage'

# in order to handle dependencies with apt, we need an apt repository that we manage fully
# easiest would probably be to create a local one
# but it wouldn't be much more difficult to push to a github account or even a ppa
# maybe we call this a dna apt-repository?

dna_aptrepo_solution = :local # or :github_upload etc etc

case dna_aptrepo_solution
when :local
when :github_upload
end

# this is temporary so we can try different repo management solutions
profile_repo_solution = :none

node.sputnik_profiles.each do |pname|
  profile = data_bag_item('sputnik_profiles', pname)

  if profile['repos']
    log "profile:#{pname} needs sputnik-repos:#{profile['repos']}"

    # We need to keep track of which profiles require which repos so
    # if we get into a state where we have two profiles that need the
    # same repo, and we remove one of those profiles, we don't
    # prematurely remove that repo...
    
    # this case statment is just so we can try different approaches
    case profile_repo_solution
    when :repo_metapackage
      # we could use metapackages that setup/teardown the repo...
      # similar to what google-chrome does when it adds their apt-repository
      # this way when the last profile-metapackage that depends on it is removed
      # the repo-metapackage is removed (via apt-get autoremove)

      
      # Repos are more than just a ppa urls, you often need the gpg key
      
      profile['repos'].each do |repo|
        metapackage "sputnik-repo-#{repo}" do
          repository repo 
        end
      end

      # Install the repo_metapackage (and apt-get update) so the
      # packages from the repo are available to the profile_metapackgae
      # If the repo_metapackage is already installed, nothing will happen
    end
    
  end
  
  log "metapackage sputnik-profile-#{pname]}:#{profile['packages']}"

  metapackage "sputnik-profile-#{pname}" do
    depends profile['packages']
  end

  # now we set the metapackage_containingrepo resources to auto-remove
  # so that running "apt-get autoremove sputnick-myprofile1" will remove
  # it's dependencies but leave any sputnik repos that are required by
  # other profiles

end
