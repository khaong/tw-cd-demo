require 'aws'

PUPPETMASTER_ELASTIC_IP = "50.19.94.106"
PUPPETMASTER_NAME_TAG = "PuppetMaster"

aws_access_key_id = ENV['AWS_ACCESS_KEY']
aws_secret_access_key = ENV['AWS_SECRET_KEY']

@ec2 = Aws::Ec2.new(aws_access_key_id, aws_secret_access_key)

def puppetmaster_already_running?
  instances = @ec2.describe_instances
  puppetmasters = instances.find_all{|instance| !instance[:tags]["Name"].nil? && instance[:tags]["Name"] == PUPPETMASTER_NAME_TAG }
  puppetmasters.any?{|pm| pm[:aws_state] == 'running'}  
end

def launch_puppetmaster
  user_data = File.read('puppetmaster-bootstrap.sh')
  instances = @ec2.launch_instances('ami-e2af508b',  :group_ids => 'PuppetMaster',
                                        :instance_type => 'm1.small',
                                        :user_data => user_data,
                                        :addressing_type => "public",
                                        :key_name => "tw-cd-demo",
                                        :availability_zone => "us-east-1b")
                                      
  instance_id = instances.first[:aws_instance_id]
  puts "Started instance #{instance_id}"
  @ec2.create_tag(instance_id, "Name", PUPPETMASTER_NAME_TAG)
  instance_id
end

def instance_running?(instance_id)
    instances = @ec2.describe_instances(instance_id)
    instances.first[:aws_state] == "running"
end

def wait_for_instance(instance_id)
  until instance_running?(instance_id)
    sleep 2
  end
end

def associate_elastic_ip(instance_id)
  @ec2.associate_address(instance_id, PUPPETMASTER_ELASTIC_IP)
end

if puppetmaster_already_running? 
  puts "PuppetMaster already running, not launching a new one" 
  exit 1
end

instance_id = launch_puppetmaster
wait_for_instance(instance_id)
associate_elastic_ip(instance_id)
