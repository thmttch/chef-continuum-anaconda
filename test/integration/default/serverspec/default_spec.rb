require 'serverspec'

set :backend, :exec

describe command('/opt/anaconda/5.0.1/bin/conda --version') do
  its(:stderr) { should match /conda 4.3.30/ }
  its(:exit_status) { should eq 0 }
end
