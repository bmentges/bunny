#!/usr/bin/env ruby

@nodename = ENV.fetch("RABBITMQ_NODENAME", "rabbit")

def rabbit_control(args)
  command = "sudo rabbitmqctl -n #{@nodename} #{args}"
  system command
end

def rabbit_plugins(args)
  command = "sudo rabbitmq-plugins #{args}"
  system command
end


# guest:guest has full access to /

rabbit_control 'add_vhost /'
rabbit_control 'add_user guest guest'
rabbit_control 'set_permissions -p / guest ".*" ".*" ".*"'


# bunny_gem:bunny_password has full access to bunny_testbed

rabbit_control 'add_vhost bunny_testbed'
rabbit_control 'add_user bunny_gem bunny_password'
rabbit_control 'set_permissions -p bunny_testbed bunny_gem ".*" ".*" ".*"'


# guest:guest has full access to bunny_testbed

rabbit_control 'set_permissions -p bunny_testbed guest ".*" ".*" ".*"'


# bunny_reader:reader_password has read access to bunny_testbed

rabbit_control 'add_user bunny_reader reader_password'
rabbit_control 'set_permissions -p bunny_testbed bunny_reader "^---$" "^---$" ".*"'

# requires RabbitMQ 3.0+
# rabbit_plugins 'enable rabbitmq_consistent_hash_exchange'
