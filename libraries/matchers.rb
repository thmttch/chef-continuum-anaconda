if defined?(ChefSpec)
  def run_bash(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new('bash', :run, resource_name)
  end
end
