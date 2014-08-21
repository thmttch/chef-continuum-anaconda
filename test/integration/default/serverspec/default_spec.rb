require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe 'general tests' do

  it 'installs anaconda 2.0.1' do
    command('/opt/anaconda/2.0.1/bin/conda --version').should return_stdout 'conda 3.5.5'
  end

end
