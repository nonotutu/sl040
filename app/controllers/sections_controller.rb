class SectionsController < InheritedResources::Base
  
  def create
    @section = Section.new(params[:section])
    if @section.save
      redirect_to @section,
          notice: generate_notice(Section, :create)
    else
      flash[:alert] = generate_notice(Section, :create, false)
      render :edit
    end
  end
  
  def update
    @section = Section.find(params[:id])
    if @section.update_attributes(params[:section])
      redirect_to @section,
          notice: generate_notice(Section, :update)
    else
      flash[:alert] = generate_notice(Section, :update, false)
      render :edit
    end
  end
  
  def destroy
    @section = Section.find(params[:id])
    if @section.destroy
      redirect_to sections_path, notice: generate_notice(Section, :destroy)
    else
      redirect_to @section,
          alert: generate_notice(Section, :destroy, false, @section.errors.full_messages)
    end
  end
  
  
end
