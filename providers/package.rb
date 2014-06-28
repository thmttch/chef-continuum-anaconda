def whyrun_supported?
  true
end

def cmd_conda
  "#{node.anaconda.install_root}/#{node.anaconda.version}/bin/conda"
end

def is_installed?(package_name)
  `"#{cmd_conda}" list`.include?(package_name)
end

def log_opts(node)
  if node.anaconda.install_log
    "2>&1 >#{node.anaconda.install_log}"
  else
    ''
  end
end

action :install do
  r = new_resource
  name = r.name
  package_name = r.package_name || name

  Chef::Log.info "installing conda package: #{package_name}"

  cmd_opts = [
    # --yes: automated install (don't ask)
    "--yes",

    r.env_name ? "--name #{r.env_name}" : '',
    r.env_path_prefix ? "--name #{r.env_path_prefix}" : '',

    r.channel ? "--channel #{r.channel}" : '',
    r.override_channels ? '--override-channels' : '',

    r.no_pin ? '--no-pin' : '',

    r.force_install ? '--force' : '',

    r.revision ? "--revision #{r.revision}" : '',
    r.file ? "--file #{r.file}" : '',
    r.unknown ? '--unknown' : '',
    r.no_deps ? '--no_deps' : '',
    r.mkdir ? '--mkdir' : '',
    r.use_index_cache ? '--use-index-cache' : '',
    r.use_local ? '--use-local' : '',
    r.alt_hint ? '--alt-hint' : '',
  ].join(" ")

  execute "conda_package_install_#{package_name}" do
    command "#{cmd_conda} install #{package_name} #{cmd_opts} #{log_opts(node)}"
    only_if { !is_installed?(package_name) || r.force_install }
  end
end

action :remove do
  r = new_resource
  name = r.name
  package_name = r.package_name || name

  Chef::Log.info "removing conda package: #{package_name}"

  cmd_opts = [
    # --yes: automated install (don't ask)
    "--yes",

    r.env_name ? "--name #{r.env_name}" : '',
    r.env_path_prefix ? "--name #{r.env_path_prefix}" : '',

    r.channel ? "--channel #{r.channel}" : '',
    r.override_channels ? '--override-channels' : '',

    r.no_pin ? '--no-pin' : '',

    r.all ? '--all' : '',
    r.features ? '--features' : '',
  ].join(' ')

  execute "conda_package_remove_#{package_name}" do
    command "#{cmd_conda} remove #{package_name} #{cmd_opts} #{log_opts(node)}"
  end
end
