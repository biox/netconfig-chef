# TODO: may be better off with the pip package here
package 'supervisor'

template '/etc/supervisor/conf.d/netconfig.conf' do
  source 'supervisor_netconfig.conf.erb'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  variables({
    user: node['netconfig']['system']['user'],
    home: node['netconfig']['installdir'],
    port: node['netconfig']['system']['port']
  })
end

netconfig_supervisor 'netconfig' do
  action :start
end
