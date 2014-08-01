require 'rubygems'
require 'capistrano-buildpack'

set :application, 'bbiz-archive'
set :repository, 'git@git.bugsplat.info:peter/bbiz-archive.git'
set :scm, :git
set :additional_domains, []

role :web, 'subspace.bugsplat.info'
set :buildpack_url, "git@git.bugsplat.info:peter/bugsplat-buildpack-ruby-simple"
set :user, 'peter'
set :base_port, 8200
set :concurrency, 'web=1'

read_env 'prod'

load 'deploy'
