require 'spec_helper'

describe 'te_agent' do

  context 'with required parameters' do
    let(:params) { {:package_source => '', :te_server_host => '', :te_services_passphrase => ''} }
    it { should contain_class('te_agent') }
  end

end
