require 'aws-sdk-eks'
require 'awspec'
require 'json'

tfvars = JSON.parse(File.read('./' + ENV['TEST_ENV'] + '.auto.tfvars.json'))
node_groups = JSON.parse(`terraform output -json cluster_node_groups`)

describe eks(tfvars["cluster_name"]) do
  it { should exist }
  it { should be_active }
  its(:version) { should eq tfvars['cluster_version'] }
end

describe 'eks managed nodegroup \'group_a\'' do
  eks_client = Aws::EKS::Client.new
  group = eks_client.describe_nodegroup( cluster_name: tfvars["cluster_name"], nodegroup_name: node_groups["group_a"]["node_group_name"] )

  context 'status' do
    it 'is expected to be active' do
      expect(group.nodegroup.status).to eq('ACTIVE')
    end
  end
  context 'instance type' do
    it 'is expected to be ' + tfvars["node_group_a_instance_types"][0] do
      expect(group.nodegroup.instance_types[0]).to eq(tfvars["node_group_a_instance_types"][0])
    end
  end
  context 'desired capacity' do
    it 'is expected to be ' + tfvars["node_group_a_desired_capacity"] do
      expect(group.nodegroup.scaling_config.desired_size).to eq(tfvars["node_group_a_desired_capacity"].to_i)
    end
  end
  context 'minimum capacity' do
    it 'is expected to be ' + tfvars["node_group_a_min_capacity"] do
      expect(group.nodegroup.scaling_config.min_size).to eq(tfvars["node_group_a_min_capacity"].to_i)
    end
  end
  context 'maximum capacity' do
    it 'is expected to be ' + tfvars["node_group_a_max_capacity"] do
      expect(group.nodegroup.scaling_config.max_size).to eq(tfvars["node_group_a_max_capacity"].to_i)
    end
  end
  context 'capacity type' do
    it 'is expected to be ' + tfvars["node_group_a_capacity_type"] do
      expect(group.nodegroup.capacity_type).to eq(tfvars["node_group_a_capacity_type"])
    end
  end
  context 'node disk size' do
    it 'is expected to be ' + tfvars["node_group_a_disk_size"] do
      expect(group.nodegroup.disk_size).to eq(tfvars["node_group_a_disk_size"].to_i)
    end
  end
end

describe iam_role(tfvars["cluster_name"] + '-cluster-autoscaler') do
  it { should exist }
end

describe iam_role(tfvars["cluster_name"] + '-cloudwatch-agent') do
  it { should exist }
end
