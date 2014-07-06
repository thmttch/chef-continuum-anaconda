if defined?(ChefSpec)

  def run_bash(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('bash', :run, resource_name)
  end

  def install_conda_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('anaconda_package', :install, resource_name)
  end

  def remove_conda_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('anaconda_package', :remove, resource_name)
  end

end
