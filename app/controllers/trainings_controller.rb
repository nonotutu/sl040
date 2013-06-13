class TrainingsController < StaffController
  
  before_filter :authenticate_user!
  load_and_authorize_resource

  
  def create
    @training = Training.new(params[:training])
    if @training.save
      redirect_to @training, notice: generate_notice(Training, :create)
    else
      flash[:alert] = generate_notice(Training, :create, false)
      render :new
    end
  end

  
  def destroy
    @training = Training.find(params[:id])
    if @training.destroy
      redirect_to trainings_path,
          notice: generate_notice(Training, :destroy)
    else
      redirect_to @training,
          alert:  generate_notice(Training, :destroy, false, @training.errors.full_messages)
    end
  end
  

  def update
    @training = Training.find(params[:id])
    if @training.update_attributes(params[:training])
      redirect_to @training,
          notice: generate_notice(Training, :update)
    else
      flash[:alert] = generate_notice(Training, :update, false)
      render :edit
    end
  end

  
end
