class ContainersController < EquipmentController

  before_filter :authenticate_user!
  load_and_authorize_resource

  
  def new
    @container = Container.new(:container_id => params[:container_id])
    @containers = containers_with_ancestors
  end

  
  def show
    @container = Container.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        pdf = InventairePdf.new(@container)
        send_data pdf.render, filename: "inventaire #{@container.name} - #{@container.created_at.strftime("%d/%m/%Y")}.pdf", type: "application/pdf"
      end
    end
  end
  

  def edit
    @container = Container.find(params[:id])
    @containers = containers_with_ancestors
  end

  
  def create
    @container = Container.new(params[:container])
    if @container.save
      redirect_to @container, notice: generate_notice(Container, :create)
    else
      @containers = containers_with_ancestors
      flash[:alert] = generate_notice(Container, :create, false)
      render :edit
    end
  end

  
  def update
    @container = Container.find(params[:id])
    if @container.update_attributes(params[:container])
      redirect_to @container, notice: generate_notice(Container, :update)
    else
      @containers = containers_with_ancestors
      flash[:alert] = generate_notice(Container, :update, false)
      render :edit
    end
  end

  
  def destroy
    @container = Container.find(params[:id])
    if @container.destroy
      redirect_to containers_path,
          notice: generate_notice(Container, :destroy)
    else
      redirect_to @container,
          alert:  generate_notice(Container, :destroy, false, @container.errors.full_messages)
    end
  end

  
private

  def containers_with_ancestors
    containers = []
    Container.order(:container_id).all.each do |container|
      container.name = container.name_with_ancestors
      containers << container
    end
  end


end
