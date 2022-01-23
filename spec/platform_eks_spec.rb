require 'awspec'
require 'json'

tfvars = JSON.parse(File.read('./' + ENV['TEST_ENV'] + '.auto.tfvars.json'))

client = Aws::EC2::Resource.new(region: tfvars['aws_region'])

ec2_instances = client.instances({
    filters: [
      {
        name: "tag:eks:cluster-name",
        values: ["#{tfvars['cluster_name']}"]
      },
      {
        name: "instance-state-name",
        values: ['running']
      }
    ]
})

describe eks(tfvars["cluster_name"]) do
  it { should exist }
  it { should be_active }
  its(:version) { should eq tfvars['cluster_version'] }
end

ec2_instances.each do |instance|
  print(instance.instance_type)
  describe tfvars['default_node_group_instance_types'] do
    it { should include instance.instance_type }
  end
end
