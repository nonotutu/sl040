# coding: utf-8
class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to error_path(:message =>  "On this page, you are not allowed to be.",
                           :author => '- Master Yoda')
  end

  
  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to error_path(:message => "Existence, this element has none.",
                           :author => '- Master Yoda')
  end

protected
  
  def generate_notice(mod, act, suc = true, err = nil)
    message = "[ #{mod.model_name.human} ] "
    case act
    when :create
      message += suc ? t(:create_ok) : t(:create_not_ok)
    when :update
      message += suc ? t(:update_ok) : t(:update_not_ok)
    when :destroy
      message += suc ? t(:destroy_ok) : t(:destroy_not_ok)
    end
    if err
      message += " → "
      err.each do |e|
        message += "#{e} / "
      end
    end
    return message
  end

  
end
