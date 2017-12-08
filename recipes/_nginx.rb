include_recipe 'nginx::default'

nginx_site 'default' do
  action :disable
end

template '/etc/nginx/sites-available/netconfig' do
  owner 'root'
  group 'root'
  mode '0755'
  source 'nginx_netconfig.erb'
  variables({
    home: node['netconfig']['installdir'],
    port: node['netconfig']['system']['port']
  })
end

nginx_site 'netconfig' do
  action :enable
end
