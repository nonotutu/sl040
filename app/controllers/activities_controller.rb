class ActivitiesController < InheritedResources::Base
  
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    
    @periodes = [['tout'],['futur']]
    
    # mise en session des paramètres - la vue travaille avec les variables de session
    [:periode].each do |param|
      if params[param]
        session[param] = params[param]
      end
    end
    
    # si reset
    if params[:reset] == 'reset'
      session[:periode] = 'futur'
    end
    
    # défauts si session vides ou absents
    session[:periode] = 'futur' unless session[:periode] || session[:periode] == ""

    periode = session[:periode] if session[:periode]
    if periode == 'tout'
      @activities = Activity.order(:starts_at).reverse
    else # ordre par défaut
      @activities = Activity.only_after(DateTime.now - 7.day).order(:starts_at).reverse
    end
    
  end

  
  def index_metro
    @activities = Activity.only_after(DateTime.now - 7.day).order(:starts_at)
    #@activities = Activity.order(:starts_at).all
  end

  
  def show_metro
    @activity = Activity.find(params[:id])
  end
  
  
  def show
    
    @activity = Activity.find(params[:id])
#     @act_need = ActNeed.find(params[:act_need_id]) if params[:act_need_id]

    @starts_delays = []
    (0..(@activity.real_end-@activity.real_start)/300-1).each do |i|
      @starts_delays << [(@activity.real_start + i*5.minutes).to_formatted_s(:cust_short), i]
    end

    nb = @starts_delays.count
    @ends_delays = []
    (1..(@activity.real_end-@activity.real_start)/300).each do |i|
      @ends_delays << [(@activity.real_start + i*5.minutes).to_formatted_s(:cust_short), nb-i]
    end
    
  end

  
  def create
    @activity = Activity.new(params[:activity])
    if @activity.save
      redirect_to @activity, notice: generate_notice(Activity, :create)
    else
      flash[:alert] = generate_notice(Activity, :create, false)
      render :new
    end
  end
  
  
  def destroy
    @activity = Activity.find(params[:id])
    if @activity.destroy
      redirect_to activities_path, notice: generate_notice(Activity, :destroy)
    else
      redirect_to @activity, alert: generate_notice(Activity, :destroy, false, @activity.errors.full_messages)
    end
  end

  
  def update
    @activity = Activity.find(params[:id])
    if @activity.update_attributes(params[:activity])
      redirect_to @activity,
          notice: generate_notice(Activity, :update)
    else
      flash[:alert] = generate_notice(Activity, :update, false)
      render :edit
    end
  end
  
  
end
