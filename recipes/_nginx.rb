include_recipe 'nginx::default'

nginx_site 'default' do
  action :disable
end

nginx_site 'netconfig' do
  template 'netconfig.erb'
  action :enable
end
