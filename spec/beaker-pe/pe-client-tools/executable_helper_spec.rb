require 'spec_helper'
require 'scooter'

class MixedWithExecutableHelper
  include Beaker::DSL::PEClientTools::ExecutableHelper
end

describe MixedWithExecutableHelper do

  let(:method_name)   { "puppet_#{tool}_on"}

  shared_examples 'pe-client-tool' do

    it 'has a method to execute the tool' do
      expect(subject.respond_to?(method_name)).not_to be(false)
    end
  end

  context 'puppet-code' do
    let(:tool) {'code'}

    it_behaves_like 'pe-client-tool'
  end

  context 'puppet-access' do
    let(:tool) {'access'}

    it_behaves_like 'pe-client-tool'
  end

  context 'puppet-job' do
    let(:tool) {'job'}

    it_behaves_like 'pe-client-tool'
  end

  context 'puppet-app' do
    let(:tool) {'app'}

    it_behaves_like 'pe-client-tool'
  end

  context 'puppet-db' do
    let(:tool) {'db'}

    it_behaves_like 'pe-client-tool'
  end

  context 'puppet-query' do
    let(:tool) {'query'}

    it_behaves_like 'pe-client-tool'
  end

  it 'has a method to login with puppet access' do
    expect(subject.respond_to?('login_with_puppet_access_on')).not_to be(false)
  end

  context 'puppet access login with lifetime parameter' do
    let(:test_host) do
      make_host('my_super_host',
                {:roles => ['master', 'agent'],
                 :platform => 'linux',
                 :type => 'pe'})
    end
    let(:username) {'T'}
    let(:password) {'Swift'}
    let(:credentials) { double('credentials', :login => username, :password => password) }
    let(:test_dispatcher) { double('dispatcher', :credentials => credentials) }

    it 'accepts correct value' do
      expect(subject).to receive(:puppet_access_on)
        .with(
          test_host,
          'login',
          '--lifetime 5d',
          {:stdin => "T\nSwift\n"}
        )
      subject.login_with_puppet_access_on(test_host, test_dispatcher, {:lifetime => '5d'})
    end
  end
end
