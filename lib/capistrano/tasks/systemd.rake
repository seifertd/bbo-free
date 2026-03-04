namespace :deploy do
  task :restart do
    on roles(:app) do
      execute :systemctl, "--user restart bbo-free.service"
    end
  end

  after :publishing, :restart
end
