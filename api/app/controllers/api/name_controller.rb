require 'json'

class Api::NameController < ApplicationController
  def index
    render status: :ok, json: JSON.parse(Invoker.new.call)
  end
end
