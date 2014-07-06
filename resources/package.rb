actions :install, :remove
default_action :install

attribute :name, :kind_of => String, :name_attribute => true

# attributes for both install and remove

attribute :package_name, :kind_of => String

attribute :env_name, :kind_of => String
attribute :env_path_prefix, :kind_of => String

attribute :channel, :kind_of => String
attribute :override_channels, :kind_of => [ TrueClass, FalseClass ]

attribute :no_pin, :kind_of => [ TrueClass, FalseClass ]

# attributes for install only

attribute :force_install, :kind_of => [ TrueClass, FalseClass ]

attribute :revision, :kind_of => String
attribute :file, :kind_of => String
attribute :unknown, :kind_of => [ TrueClass, FalseClass ]
attribute :no_deps, :kind_of => [ TrueClass, FalseClass ]
attribute :mkdir, :kind_of => [ TrueClass, FalseClass ]
attribute :use_index_cache, :kind_of => [ TrueClass, FalseClass ]
attribute :use_local, :kind_of => [ TrueClass, FalseClass ]
attribute :alt_hint, :kind_of => [ TrueClass, FalseClass ]

# attributes for remove only

attribute :all, :kind_of => [ TrueClass, FalseClass ]
attribute :features, :kind_of => [ TrueClass, FalseClass ]
