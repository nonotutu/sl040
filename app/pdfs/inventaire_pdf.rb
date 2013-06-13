#encoding: utf-8

class InventairePdf < PdfInventaire

  require "prawn/measurement_extensions"
  
  def initialize(container)
    super(:page_size => "A4", :margin => [10.mm,10.mm,10.mm,10.mm])

    registering_police_dejavusans
    registering_police_dejavusansmono
    registering_police_dejavusanscondensed

    titre_inventaire(container)
    
    content(container)
    
    number_pages "<page> / <total>", {:start_count_at => 1,
                                      :at => [bounds.left, bounds.top - 3.mm],
                                      :align => :left,
                                      :size => 12}
    
  end

end


