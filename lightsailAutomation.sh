#!/bin/bash
if [ $# -ne 4 ]; then
echo "Usage: $0 <server_name> <instance_plan> <region> <blueprint_id>"
exit 1
fi

#Assign command-line arguments to variables
server_name="$1"  # The name of your Lightsail server instance
instance_plan="$2"    # The instance plan for your server
region="$3"                # The AWS region where you want to create the server
blueprint_id="$4"        # The ID of the OS blueprint for your server


# Create a new Lightsail instance
aws lightsail create-instances \
    --instance-names "$server_name" \
    --availability-zone "$region" \
    --blueprint-id "$blueprint_id" \
    --bundle-id "$instance_plan" \
    --user-data '#!/bin/bash\napt update -y && apt upgrade -y' \
    --tags "key=Name,value=$server_name"

# Wait for the instance to be running
aws lightsail wait instance-running --instance-name "$server_name"

# Get the public IP address of the instance
ip_address=$(aws lightsail get-instance --instance-name "$server_name" 
--query "instance.publicIpAddress" --output text)

# Print the server details
echo "Server setup is complete!"
echo "Server name: $server_name"
echo "Public IP address: $ip_address"
