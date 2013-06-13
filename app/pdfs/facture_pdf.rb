#encoding: utf-8

class FacturePdf < Pdf

  require "prawn/measurement_extensions"


  def initialize(department_id,
                 adresse,
                 lieu,
                 date,
                 type,
                 numero,
                 reference,
                 tab_infos,
                 date_rappel_0,
                 date_rappel_1,
                 date_rappel_2,
                 tab_facture,
                 total_facture,
                 contact)

    super(:page_size => "A4", :margin => [20.mm,20.mm,20.mm,20.mm])

    registering_police_dejavusans
    registering_police_dejavusansmono
    registering_police_dejavusanscondensed


    header(department_id)


    move_down 8.mm
    cadre_adresse(adresse)

    move_down 8.mm
    lieu_date(lieu, date)


    move_down 8.mm
    case type
    when 'facture'
      titre("FACTURE n°#{numero}")
    when 'devis'
      titre("DEVIS")
    when 'rappel'
      if date_rappel_2
        titre("3e RAPPEL")
      else
        if date_rappel_1
          titre("2e RAPPEL")
        else
          titre("1e RAPPEL")
        end
      end
    end

    if type == 'rappel'
      move_down 8.mm
      font_size 11
      text "Facture initiale : #{numero}, #{date_rappel_0}"
      if date_rappel_1
        text "Date premier rappel : #{date_rappel_1}"
        if date_rappel_2
          text "Date deuxième rappel : #{date_rappel_2}"
        end
      end
    end

    info_en_cours = false

    unless reference.blank?
      move_down info_en_cours ? 4.mm : 8.mm
      info('Nos références', reference)
      info_en_cours = true
    end

    unless tab_infos.empty?
      move_down info_en_cours ? 4.mm : 8.mm
      tab_infos.each do |i|
        info(i[0], i[1])
        move_down 1.mm
      end
      info_en_cours = true
    end

    unless contact.blank?
      move_down info_en_cours ? 4.mm : 8.mm
      info("Votre contact", contact)
      info_en_cours = true
    end


    move_down 8.mm

    tableau_ligne([{texte: "Dénomination", largeur: 85},
                   {texte: "Qté", largeur: 25},
                   {texte: "P/U", largeur: 30},
                   {texte: "Montant", largeur: 30}],
                   fill: "CFCFCF",
                   default_style: :bold,
                   size: 9)
    
    tab_facture.each do |ii|
      tableau_ligne([{texte: ii[0], largeur: 85},
                     {texte: ii[1], largeur: 25, align: :right},
                     {texte: ii[2], largeur: 30, align: :right},
                     {texte: ii[3], largeur: 30, align: :right}],
                     size: 8,
                     lignes_horizontales: false)
    end
    
    tableau_ligne([{texte: "Total", largeur: 140},
                   {texte: total_facture, largeur: 30, align: :right}],
                   fill: "CFCFCF",
                   default_style: :bold,
                   size: 9)

    move_down 8.mm
    if type == 'facture' || type == 'rappel'
      cadre_total_a_payer(total_facture)
    elsif type == 'devis'
      cadre_total(total_facture)
    end


    conditions_facturation()

    footer()

  end


  
  def conditions_facturation
  
    move_cursor_to bounds.bottom + 8.mm
    
    font_size 6
    
    text "La tarification est d'application du 1er janvier 2012 au 31 décembre 2013."
    text "Notre facturation est soumise aux conditions générales, disponibles sur simple demande."

  end


  
  def cadre_total(total)
    
    font_size 11

    bounding_box([bounds.left+55.mm,cursor], :width => 60.mm) do
      bounding_box([bounds.left,bounds.top-2.mm], :width => 60.mm) do
        font_size 14
        text "Total :  #{total}", :style => :bold, align: :center
      end
      line_width 1
      stroke_bounds
    end
    
  end



  def cadre_total_a_payer(total)
    
    font_size 11

    bounding_box([bounds.left+22.mm,cursor], :width => 126.mm) do
      cell :background_color => 'E8E8D0', :width => bounds.right-bounds.left, :height => bounds.top-bounds.bottom, :align => :center, :text_color => "001B76"
      bounding_box([bounds.left+2.mm,bounds.top-2.mm], :width => 126.mm-2.mm) do
        font_size 14
        text "Total à payer : #{total}", :style => :bold
        font_size 11
        text "Payable au comptant sur le compte ING BE90 3100 0858 8832"
      end
      move_down 1.mm
      line_width 1
      stroke_bounds
    end
    
  end

end


