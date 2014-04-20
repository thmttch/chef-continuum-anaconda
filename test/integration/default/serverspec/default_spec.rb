require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

describe 'general tests' do

  it 'installs conda' do
    command('/opt/anaconda/1.9.2/bin/conda --version').should return_stdout 'conda 3.4.1'
  end

end
