class PurchasesController < EquipmentController

  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def new
    @purchase = Purchase.new(item_id: params[:item_id])
  end
  
end
