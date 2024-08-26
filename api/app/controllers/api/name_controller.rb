class Api::NameController < ApplicationController
  def index
    render status: :ok, json: { name: 'ta9ma0k' }
  end
end
