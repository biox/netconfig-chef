resource_name :netconfig_supervisor

property :service_name, String, name_property: true

require 'mixlib/shellout'

def get_current_state(service_name)
  result = Mixlib::ShellOut.new("supervisorctl status").run_command
  match = result.stdout.match("(^#{service_name}(\\:\\S+)?\\s*)([A-Z]+)(.+)")
  if match.nil?
    "UNAVAILABLE"
  else
    match[3]
  end
end

def wait_til_state(state,max_tries=20)
  service = new_resource.service_name

  max_tries.times do
    return if get_current_state(service) == state

    Chef::Log.debug("Waiting for service #{service} to be in state #{state}")
    sleep 1
  end

  raise "service #{service} not in state #{state} after #{max_tries} tries"

end

action :start do
  execute "supervisorctl update" do
    user "root"
  end

  case get_current_state(new_resource.service_name)
  when 'UNAVAILABLE'
    raise "Supervisor service #{new_resource.service_name} cannot be started because it does not exist"
  when 'RUNNING'
    Chef::Log.debug "#{new_resource.service_name} is already started."
  when 'STARTING'
    Chef::Log.debug "#{new_resource.service_name} is already starting."
    wait_til_state("RUNNING")
  else
    converge_by("Starting #{new_resource.service_name}") do
      if not supervisorctl('start')
        raise "Supervisor service #{new_resource.service_name} was unable to be started"
      end
    end
  end
end
