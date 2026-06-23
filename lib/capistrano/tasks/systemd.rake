require "erb"
require "stringio"

namespace :deploy do
  # Path to the user systemd unit on the target host (relative to $HOME).
  set :systemd_user_dir, -> { ".config/systemd/user" }
  # Port the Rails server binds to (nginx proxies to this).
  set :app_port, -> { 3000 }

  desc "Install/update the systemd user unit from the version-controlled template"
  task :install_systemd_unit do
    # Evaluated here, at task-body level, where the Capistrano DSL is available.
    application       = fetch(:application)
    working_directory = current_path
    rails_env         = fetch(:rails_env, "production")
    app_port          = fetch(:app_port)
    rvm_path          = fetch(:rvm_path, "/usr/local/rvm")
    # The rvm wrapper for the deployed ruby@gemset — the single source of truth
    # that keeps the unit's ruby in sync with :rvm_ruby_version on every deploy.
    wrapper_bin       = "#{rvm_path}/wrappers/#{fetch(:rvm_ruby_version)}/bundle"

    template = File.expand_path("../../../../config/deploy/templates/systemd_service.erb", __FILE__)
    rendered = ERB.new(File.read(template), trim_mode: "-").result(binding)

    unit_dir = fetch(:systemd_user_dir)
    unit     = "#{unit_dir}/#{application}.service"

    on roles(:app) do
      execute :mkdir, "-p", unit_dir
      upload! StringIO.new(rendered), unit
      execute :systemctl, "--user", "daemon-reload"
    end
  end

  task :restart do
    on roles(:app) do
      execute :systemctl, "--user", "restart", "#{fetch(:application)}.service"
    end
  end

  after :publishing, :install_systemd_unit
  after :install_systemd_unit, :restart
end
