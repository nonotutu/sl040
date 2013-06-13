class DepartmentsController < InheritedResources::Base
  
  before_filter :authenticate_user!
  load_and_authorize_resource

  
  def create
    @department = Department.new(params[:department])
    if @department.save
      redirect_to @department, notice: generate_notice(Department, :create)
    else
      flash[:alert] = generate_notice(Department, :create, false)
      render :new
    end
  end

  
  def destroy
    @department = Department.find(params[:id])
    if @department.destroy
      redirect_to departments_path,
          notice: generate_notice(Department, :destroy)
    else
      redirect_to @department,
          alert:  generate_notice(Department, :destroy, false, @department.errors.full_messages)
    end
  end
  

  def update
    @department = Department.find(params[:id])
    if @department.update_attributes(params[:department])
      redirect_to @department,
          notice: generate_notice(Department, :update)
    else
      flash[:alert] = generate_notice(Department, :update, false)
      render :edit
    end
  end


  
end
