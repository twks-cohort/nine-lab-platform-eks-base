require 'awspec'
require 'json'

tfvars = JSON.parse(File.read('./' + ENV['TEST_ENV'] + '.auto.tfvars.json'))

describe eks(tfvars["cluster_name"]) do
  it { should exist }
  it { should be_active }
  its(:version) { should eq tfvars['cluster_version'] }
end

describe eks_nodegroup("group_a"), cluster: tfvars["cluster_name"] do
  it { should exist }
  its(:instance_types) { should eq tfvars["node_group_a_instance_types"] }
  its(:disk_size) { should eq tfvars["node_group_a_disk_size"] }
end

describe iam_role(tfvars["cluster_name"] + '-cluster-autoscaler') do
  it { should exist }
end

describe iam_role(tfvars["cluster_name"] + '-cloudwatch-agent') do
  it { should exist }
end
