#coding: utf-8
class EquipmentController < InheritedResources::Base
 
  before_filter :authenticate_user!

  
  def index
    authorize! :equipment, :index
  end

  
  def table_items_containers
    
    authorize! :equipment, :table_items_containers
    
    @table_add = []

    @table_all = []
    row = []
    row << "cat" << "item"
    Container.racine.each do |container|
      2.times do
        row << "#{container}" + (container.quantity > 1 ? " × #{container.quantity}" : "")
      end
    end
    @table_all << row
    Item.includes(:containers).order(:container['id']).each do |item| # TODO: join & order dont work on heroku
      row = []
      row << item.category.short_name << item.to_s
      Container.racine.each do |container|
        q = 0
        qu = 0
        c = ""
        item.contents.all.each do |content|
          if find_root(content.container) == container
            if content.unitary
              qu += content.quantity
            else
              q += content.quantity
            end
            c += "#{content.container}"
            c += " × #{content.container.quantity}" if content.container.quantity > 1
            c += "; "
          end
        end
        row << ( (qu > 0 ? "*" + qu.to_s : "" ) + ( q > 0 && qu > 0 ? " + " : "" ) + ( q > 0 ? q.to_s : "" ) )
        row << c
      end
      @table_all << row
    end
      
  end
  
  private
  
  def visiter_container(container, item)
  end
  
  def find_root(container)
    if container.container
      find_root(container.container)
    else
      return container
    end
  end

end