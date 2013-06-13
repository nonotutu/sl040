class ContentsController < EquipmentController
  
  belongs_to :container

  before_filter :authenticate_user!
  load_and_authorize_resource

  
  def new
    
    @container = Container.find(params[:container_id])
    @content = Content.new(:container_id => @container.id)
    
    @containers = [] # TODO : méthode globale
    Container.order(:container_id).all.each do |container| # TODO : méthode globale
      container.name = container.name_with_ancestors
      @containers << container
    end
       
  end

  
  def edit
    
    @container = Container.find(params[:container_id])
    @content = Content.find(params[:id])
    
    @containers = [] # TODO : méthode globale
    Container.order(:container_id).all.each do |container| # TODO : méthode globale
      container.name = container.name_with_ancestors
      @containers << container
    end
       
  end
  
  
  def index
    
    @container = Container.find(params[:container_id])
    
    @contenu = @container.contenu
    @max_indent = @container.stack_deep
    
#     @contenu = []
#     @indent = 1
#     @max_indent = 1
#     @contenu << [0, @container]
#     peupler_articles(@container, @indent)
#     visiter_container(@container)
       
  end
  
#   
#   private
# 
#   
#   def visiter_container(container)
#     container.containers.order(:pos).each do |cont|
#       @contenu << [@indent, cont]
#       peupler_articles(cont, @indent += 1)
#       @max_indent = @indent if @indent > @max_indent
#       visiter_container(cont)
#     end
#     @indent -= 1
#   end
# 
#   
#   def peupler_articles(container, indent)
#     container.contents.order(:pos).each do |content|
#       @contenu << [indent, content]
#     end
#   end

  
end
