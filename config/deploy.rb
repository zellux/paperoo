# -*- coding: utf-8 -*-
require 'bundler/capistrano'

set :user, 'rails'
set :domain, 'paperoo.yxwang.me'
set :application, 'paperoo'
set :applicationdir, '/home/rails/paperoo'

set :scm, "git"
set :repository, 'git@github.com:zellux/paperoo.git'
set :branch, 'master'
set :git_shallow_clone, 1
set :scm_verbose, true

role :web, domain
role :app, domain
role :db, domain, :primary => true

set :deploy_to, applicationdir
set :deploy_via, :export
set :use_sudo, false
set :backup_dir, '/home/rails/backup'

default_run_options[:pty] = true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :symlink_config, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/lib/secret.rb #{release_path}/lib/secret.rb"
  end

  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/static/assets #{release_path}/public/assets"
  end
end

before "deploy", "backup"

set :unicorn_pid, "#{shared_path}/pids/unicorn.pid"

after 'deploy:update_code', 'deploy:symlink_shared'
before 'deploy:finalize_update', 'deploy:symlink_config'
# after 'deploy:finalize_update', 'deploy:assets:precompile'
# before "deploy:assets:precompile", "bundle:install"

namespace :deploy do
  task :start do
    top.unicorn.start
  end

  task :stop do
    top.unicorn.stop
  end

  task :restart do
    top.unicorn.restart
  end
end

namespace :unicorn do
  desc "start unicorn"
  task :start, :roles => :app do
    run "cd #{current_path} && bundle exec unicorn_rails -p 4000 -E production -D"
  end

  desc "stop unicorn"
  task :stop, :roles => :app do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end

  desc "restart unicorn"
  task :restart, :roles => :app do
    top.unicorn.stop
    top.unicorn.start
  end

  desc "reload unicorn (gracefully restart workers)"
   task :reload, :roles => :app do
     run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
   end

  desc "reconfigure unicorn (reload config and gracefully restart workers)"
  task :reconfigure, :roles => :app do
    run "#{try_sudo} kill -s HUP `cat #{unicorn_pid}`"
  end
end

# Backup
task :backup, :roles => :db, :only => { :primary => true } do
  filename = "#{backup_dir}/#{application}.dump.#{Time.now.to_f}.sql.bz2"
  text = capture "cat #{deploy_to}/shared/config/database.yml"
  yaml = YAML::load(text)

  on_rollback { run "rm #{filename}" }
  run "mysqldump -u #{yaml['production']['username']} -p #{yaml['production']['database']} | bzip2 -c > #{filename}" do |ch, stream, out|
    ch.send_data "#{yaml['production']['password']}\n" if out =~ /^Enter password:/
  end
end
