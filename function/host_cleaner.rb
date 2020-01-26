require 'aws-sdk-eventbridge'
require 'aws-sdk-ecs'

def exec(event:, context:)
  # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/EventBridge.html
  begin
    host_name = event['detail']['host']['name']
    event_name = event['detail']['event']
    is_retired = event['detail']['host']['isRetired']
    host_status = event['detail']['host']['status']
    printf('host_name: %s, event_name: %s, is_retired: %s, host_status: %s ', host_name, event_name, is_retired, host_status)

    # TODO Check event

    if host_status == 'poweroff' && is_retired == false

      # https://docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/ECS.html
      ecs = Aws::ECS::Client.new(
        region: 'ap-northeast-1'
      )

      # May Yasashisa
      resp = ecs.stop_task({
        cluster: ENV['CLUSTER_NAME'],
        task: host_name,
        reason: "The host status is changed to poweroff on Mackerel"
      })
      p resp

      # TODO message?
    end
  # do stuff
  rescue Aws::EventBridge::Errors::ServiceError
    # rescues all service API errors
    # TODO Impl
  end
end
