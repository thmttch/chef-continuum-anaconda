actions :create
default_action :create

attribute :name, :kind_of => String, :name_attribute => true

attribute :service_action, :kind_of => Array

attribute :ip, :kind_of => String
attribute :port, :kind_of => String

attribute :user, :kind_of => String
attribute :group, :kind_of => String

attribute :install_dir, :kind_of => String

# if you really need it
attribute :pythonpath, :kind_of => Array
attribute :pythonstartup, :kind_of => String
attribute :files_to_source, :kind_of => Array

attribute :template_cookbook, :kind_of => String
attribute :run_template_name, :kind_of => String
attribute :run_template_opts, :kind_of => Hash
