require 'serverspec'

describe command('/opt/anaconda/2.2.0/bin/conda --version') do
  its(:stdout) { should match /conda 3.10.0/ }
end
