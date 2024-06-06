function start_session -d 'Start Session'
    set -l instance (aws ec2 describe-instances --query "Reservations[*].Instances[*].[InstanceId, Tags[?Key=='Name'].Value | [0] ]" --output text | grep "bastion" | sort | fzf --multi)
    set -l instance_id (echo $instance | awk '{print $1}')
    aws ssm start-session --target $instance_id
end
