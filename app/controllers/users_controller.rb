class UsersController < InheritedResources::Base

  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    @users = User.all
  end

  
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to @user, notice: generate_notice(User, :create)
    else
      flash[:alert] = generate_notice(User, :create, false)
      render :new
    end
  end
  

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to users_path,
          notice: generate_notice(User, :destroy)
    else
      redirect_to @user,
          alert:  generate_notice(User, :destroy, false, @user.errors.full_messages)
    end
  end
  

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to @user,
          notice: generate_notice(User, :update)
    else
      flash[:alert] = generate_notice(User, :update, false)
      render :edit
    end
  end


  
end
