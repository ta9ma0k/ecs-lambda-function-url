class Api::NameController < ApplicationController
  def index
    invoker = Invoker.new
    lambda_result = invoker.call
    render status: :ok, json: { lambda_result: }
  end
end
