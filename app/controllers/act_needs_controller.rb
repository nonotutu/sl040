# coding: utf-8
class ActNeedsController < InheritedResources::Base
  
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
    @act_need = ActNeed.new(params[:act_need])
    if @act_need.save
      redirect_to @act_need.activity,
          notice: generate_notice(ActNeed, :create)
    else
      # TODO : le formulaire devrait préafficher les champs erronés
      flash[:alert] = generate_notice(ActNeed, :create, false)
      redirect_to controller: :activities, action: :show, id: @act_need.activity_id,
          params: { act_need: @act_need, act_need_errors: @act_need.errors.full_messages }
    end
  end

  
  def destroy
    @act_need = ActNeed.find(params[:id])
    if @act_need.destroy
      redirect_to @act_need.activity,
          notice: generate_notice(ActNeed, :destroy)
    else
      redirect_to @act_need.activity,
          alert:  generate_notice(ActNeed, :destroy, false, @act_need.errors.full_messages)
    end
  end
  
  
  def update
    @act_need = ActNeed.find(params[:id])
    if @act_need.update_attributes(params[:act_need])
      redirect_to @act_need.activity, 
          notice: generate_notice(ActNeed, :update)
    else
      # TODO : le formulaire devrait préafficher les champs erronés
      flash[:alert] = generate_notice(ActNeed, :update, false)
      redirect_to controller: :activities, action: :show, id: @act_need.activity_id,
          params: { act_need: @act_need, act_need_errors: @act_need.errors.full_messages }
    end
  end
    

end
