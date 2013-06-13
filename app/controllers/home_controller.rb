#coding: UTF-8
class HomeController < ApplicationController

  before_filter :authenticate_user!, :except => :index

  
  def index
    authorize! :home, :index
  end
    
  def google_drive
    authorize! :home, :google_drive
  end
  
end
