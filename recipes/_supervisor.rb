package 'supervisor'

template '/etc/supervisor/conf.d/netconfig.conf' do
  owner 'root'
  group 'root'
  source 'netconfig.conf.erb'
end
