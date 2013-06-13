class CertificatesController < StaffController
  
  belongs_to :volunteer

  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def new
    @certificate = Certificate.new(training_id: params[:training_id], volunteer_id: params[:volunteer_id])
  end
  
  def create
    @certificate = Certificate.new(params[:certificate])
    if @certificate.save
      redirect_to [@certificate.volunteer, @certificate], notice: generate_notice(Certificate, :create)
    else
      flash[:alert] = generate_notice(Certificate, :create, false)
      render :new
    end
  end
  

  def destroy
    @certificate = Certificate.find(params[:id])
    if @certificate.destroy
      redirect_to volunteer_path(@certificate.volunteer),
          notice: generate_notice(Certificate, :destroy)
    else
      redirect_to volunteer_certificate_path(@certificate),
          alert:  generate_notice(Certificate, :destroy, false, @certificate.errors.full_messages)
    end
  end

  
  def update
    @certificate = Certificate.find(params[:id])
    if @certificate.update_attributes(params[:certificate])
      redirect_to [@volunteer, @certificate],
          notice: generate_notice(Certificate, :update)
    else
      flash[:alert] = generate_notice(Certificate, :update, false)
      render :edit
    end
  end
  
  
end
