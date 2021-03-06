require 'test_helper'

class BaseControllerTest < ActionController::TestCase
  def setup
    @controller = MyMoipRails::BaseController.new
  end

  def teardown
    if @controller.respond_to?(:original_params)
      @controller.class.class_eval do
        alias_method :params, :original_params
      end
      @controller.class.instance_eval do
        remove_method(:original_params)
      end
    end
  end

  test "done method run its block when params variable has status_pagamento 4" do
    @controller.class.class_eval do
      alias_method :original_params, :params
    end
    @controller.class.send(:define_method, :params) do
      { status_pagamento: '4' }
    end
    a_stub = stub
    a_stub.expects(:done!).once
    @controller.done do
      a_stub.done!
    end
  end

  test "done method don't run its block when params variable has status_pagamento other than 4" do
    @controller.class.class_eval do
      alias_method :original_params, :params
    end
    @controller.class.send(:define_method, :params) do
      { status_pagamento: '5' }
    end
    a_stub = stub
    a_stub.expects(:done!).never
    @controller.done do
      a_stub.done!
    end
  end
end
