require 'serverspec'

set :backend, :exec

describe command('/opt/anaconda/2.3.0/bin/conda --version') do
  its(:stderr) { should match /conda 3.14.1/ }
  its(:exit_status) { should eq 0 }
end
