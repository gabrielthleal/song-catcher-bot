require 'test_helper'

class WebhooksControllerTest < ActionDispatch::IntegrationTest
  test "should get callback" do
    get webhooks_callback_url
    assert_response :success
  end

end
