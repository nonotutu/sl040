# coding: utf-8
class RegistrationsController < InheritedResources::Base
  
  belongs_to :activity
  
  def index
  end
  
  def new
  end
  
  def show
  end
   
  def edit
  end


  def create
    @registration = Registration.new(params[:registration])
    if @registration.save
      redirect_to @registration.activity,
          notice: generate_notice(Registration, :create)
    else
      # TODO : le formulaire devrait préafficher les champs erronés
      flash[:alert] = generate_notice(Registration, :create, false)
      redirect_to controller: :activities, action: :show, id: @registration.activity, 
          params: { registration: @registration, registration_errors: @registration.errors.full_messages }
    end
  end

  
  def destroy
    @registration = Registration.find(params[:id])
    if @registration.destroy
      redirect_to @registration.activity,
          notice: generate_notice(Registration, :destroy)
    else
      redirect_to @registration.activity,
          alert:  generate_notice(Registration, :destroy, false, @registration.errors.full_messages)
    end
  end
  
  
  def update
    @registration = Registration.find(params[:id])
    if @registration.update_attributes(params[:registration])
      redirect_to @registration.activity,
          notice: generate_notice(Registration, :update)
    else
      # TODO : le formulaire devrait préafficher les champs erronés
      flash[:alert] = generate_notice(Registration, :update, false)
      redirect_to controller: :activities, action: :show, id: @registration.activity_id,
          params: { registration: @registration, registration_errors: @registration.errors.full_messages }
    end
  end
    
  
  def confirmer_presence
    
    @registration = Registration.find(params[:id])
    authorize! :confirmer_presence, @registration
    
    @registration.status_id = nil
    if @registration.save
      redirect_to activity_metro_path(@registration.activity_id),
          notice: generate_notice(Registration, :update)
    else
      redirect_to activity_metro_path(@registration.activity_id),
          notice: generate_notice(Registration, :update, false)
    end
  end

  
#   def status # not used now
#     @activity = Activity.find(params[:activity_id])
#     @registration = Registration.where(activity_id: @activity.id).find(params[:id])
#   end
  
end
