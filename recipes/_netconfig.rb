%w[python-dev gunicorn libssl-dev libsasl2-dev git python python-pip].each do |pkg|
  package pkg do
    action :install
  end
end

user node['netconfig']['system']['user'] do
  action :create
end

directory node['netconfig']['installdir'] do
  mode '0750'
  owner node['netconfig']['system']['user']
  group node['netconfig']['system']['group']
  action :create
end

git 'Downlaod netconfig' do
  repository 'https://github.com/v1tal3/netconfig.git'
  reference 'master'
  destination node['netconfig']['installdir']
  user node['netconfig']['system']['user']
  group node['netconfig']['system']['group']
end

python_runtime '2'

python_package 'uWSGI' do
  user 'root'
  version '2.0.15'
end

pip_requirements "#{node['netconfig']['installdir']}/requirements.txt" do
  user 'root'
  action :install
end

systemd_unit 'netconfig.service' do
  content({
     Unit: {
       Description: 'Netconfig',
       Documentation: 'https://github.com/v1tal3/netconfig',
       After: 'network.target',
     },
     Service: {
       Type: 'notify',
       Environment: 'PATH=/usr/bin/python',
       User: node['netconfig']['system']['user'],
       Group: node['netconfig']['system']['group'],
       WorkingDirectory: node['netconfig']['installdir'],
       ExecStart: '/usr/local/bin/uwsgi --ini netconfig.ini',
       Restart: 'always',
     },
     Install: {
       WantedBy: 'multi-user.target',
     },
   })
  action :create
end

service 'netconfig' do
  action ['enable', 'start']
end
