class TemplateController < ApplicationController
  skip_before_filter :authenticate
  layout false
  def index
    render '/templates/index', layout: 'application'
  end
  def show
    render "templates/#{params[:ng_controller]}/#{params[:ng_action]}"
  end
end
