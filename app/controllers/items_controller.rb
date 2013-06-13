class ItemsController < EquipmentController
  
  before_filter :authenticate_user!
  load_and_authorize_resource 

  def index
  
    @categories = []
    @categories << ['all','all categories']
    Category.all.each do |categ|
      @categories << [categ.id, categ.name]
    end

    @orders = [['category'],
               ['nature'],
               ['produit']]
    
    # mise en session des paramètres - la vue travaille avec les variables de session
    [:order, :category, :search].each do |param|
      if params[param]
        session[param] = params[param]
      end
    end
    
    # si reset
    if params[:reset] == 'reset'
      session[:order] = 'category'
      session[:category] = 'all'
      session[:search] = ''
    end
    
    # défauts si session vides ou absents
    session[:order] = 'category' unless session[:order] || session[:order] == ""
    session[:category] = 'all' unless session[:category] || session[:category] == ""
    session[:search] = '' unless session[:search] || session[:search] == ""


    order = session[:order] if session[:order]
    if order == 'nature'
      @items = Item.order(:nature)
    elsif order == 'produit'
      @items = Item.order(:produit)
    else # ordre par défaut
      @items = Item.includes(:category).order('categories.name').order(:nature).order(:produit)
    end

    
    category = session[:category] if session[:category]
    if category && category != "all"
      @items = @items.only_category(category)
    end

    
    search = session[:search].strip if session[:search]
    if search && search != ""
      @result = []
      ( search.split << search ).each do |s|
        @items.each do |item|
          ss = UnicodeUtils.downcase(s).parameterize
          if UnicodeUtils.downcase(item.nature).parameterize.include?(ss)
            @result << item unless @result.include?(item)
          end
          if UnicodeUtils.downcase(item.produit).parameterize.include?(ss)
            @result << item unless @result.include?(item)
          end
        end
        @items = @result
      end
    end

  end
      
  
  def show
    @item = Item.find(params[:id])
  end
  
  def create
    @item = Item.new(params[:item])
    if @item.save
      redirect_to @item, notice: generate_notice(Item, :create)
    else
      flash[:alert] = generate_notice(Item, :create, false)
      render :edit
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(params[:item])
      redirect_to @item, notice: generate_notice(Item, :update)
    else
      flash[:alert] = generate_notice(Item, :update, false)
      render :edit
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    if @item.destroy
      redirect_to items_path,
          notice: generate_notice(Item, :destroy)
    else
      redirect_to @item,
          alert:  generate_notice(Item, :destroy, false, @item.errors.full_messages)
    end
  end


end
