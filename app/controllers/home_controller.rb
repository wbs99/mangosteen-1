class HomeController < ApplicationController
  def index
    render json: {
      message: "Welcome to mangosteen",
    }
  end
end
