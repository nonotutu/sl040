class VolunteersController < StaffController
  
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  # 0478 380 613
  
  def index_metro
    index
  end
  
  def index
    
    @departments = []
    @departments << ['all', "tous"]
    Department.all.each do |department|
      @departments << [department.id, department.name]
    end
    @departments << ['none', "aucun"]
    
    @sections = []
    Section.all.each do |section|
      @sections << [section.id, section]
    end

    @orders = [['pos', Volunteer.human_attribute_name(:pos)],
               ['first_name', Volunteer.human_attribute_name(:first_name)],
               ['last_name', Volunteer.human_attribute_name(:last_name)],
               ['date_of_birth', Volunteer.human_attribute_name(:date_of_birth)],
               ['birthday', 'anniversaire']]

    # mise en session des paramètres - la vue travaille avec les variables de session
    [:vol_order, :department, :active, :vol_section].each do |param|
      if params[param]
        session[param] = params[param]
      end
    end
    
    # si reset
    if params[:reset] == 'reset'
      session[:vol_order] = 'pos'
      session[:department] = 'all'
      session[:vol_section] = '1' # TODO : current_user.section
    end
    
    # défauts si session vides ou absents
    session[:vol_order]   = :pos  unless session[:vol_order]   || session[:vol_order]   == ""
    session[:department]  = 'all' unless session[:department]  || session[:department]  == ""
    session[:vol_section] = '1'   unless session[:vol_section] || session[:vol_section] == "" # TODO : current_user.section

    order = session[:vol_order] if session[:vol_order]
    if order
      if order == 'birthday'
        @volunteers = Volunteer.where('date_of_birth IS NOT NULL').sort_by{ |v| [v.date_of_birth.month, v.date_of_birth.day] }
      else
        @volunteers = Volunteer.order(order)
      end
    else # ordre par défaut
      @volunteers = Volunteer.order(:pos)
    end

    section = session[:vol_section] if session[:vol_section]
    if section
      @volunteers &= Volunteer.only_section(section.to_i)
    end  
    
    department = session[:department] if session[:department]
    if department
      if department != "all" && department != "none"
        @volunteers &= Volunteer.only_department(department.to_i)
      elsif department == "none"
        @flag_inactive = true
        @volunteers &= Volunteer.only_not_active
      elsif department == "all"
        @volunteers &= Volunteer.only_active
      end
    end  
        
    @mailing_list = ''
    @volunteers.each do |volunteer|
      @mailing_list += "#{volunteer.email}; " if volunteer.email != ''
    end
    
    respond_to do |format|
      format.html
      format.csv { send_data volunteers_to_csv(params[:default] == 'default' ? nil : @volunteers) }
    end
    
  end
  
  
  def new
    pos = Volunteer.count > 0 ? Volunteer.last.pos + 1 : 1
    @volunteer = Volunteer.new(pos: pos)
  end
  
  
  def show
    @volunteer = Volunteer.find(params[:id])
    @certificates = @volunteer.certificates.order(:issued_on)
    authorize! :read, @volunteer
  end

  
  def show_metro
    authorize! :show_metro, Volunteer
    @volunteer = Volunteer.find(params[:id])
    @certificates = Certificate.unscoped.where(:volunteer_id => @volunteer).order(:issued_on)
  end
  
  
  def create
    @volunteer = Volunteer.new(params[:volunteer])
    if @volunteer.save
      redirect_to @volunteer, notice: generate_notice(Volunteer, :create)
    else
      flash[:alert] = generate_notice(Volunteer, :create, false)
      render :new
    end
  end

  
  def update
    @volunteer = Volunteer.find(params[:id])
    if @volunteer.update_attributes(params[:volunteer])
      redirect_to @volunteer,
          notice: generate_notice(Volunteer, :update)
    else
      flash[:alert] = generate_notice(Volunteer, :update, false)
      render :edit
    end
  end

  
  def destroy
    @volunteer = Volunteer.find(params[:id])
    if @volunteer.destroy
      redirect_to volunteers_path,
          notice: generate_notice(Volunteer, :destroy)
    else
      redirect_to @volunteer,
          alert:  generate_notice(Volunteer, :destroy, false, @volunteer.errors.full_messages)
    end
  end
  
  
  
end
