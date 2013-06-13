#encoding: utf-8

class BonDeCommandePdf < Pdf

  require "prawn/measurement_extensions"


  def initialize(department_id,
                 date,
                 destinataire,
                 reference_offre,
                 reference_client,
                 adresse_fl,
                 demandeur,
                 tab_commande,
                 total_htva,
                 total_tva,
                 total_tvac,
                 signature
                 )

    super(:page_size => "A4", :margin => [20.mm,20.mm,20.mm,20.mm])

    registering_police_dejavusans
    registering_police_dejavusansmono
    registering_police_dejavusanscondensed


    header(department_id)


    move_down 8.mm

    titre("BON DE COMMANDE")


    move_down 8.mm

    deux_colonnes([[['date :', date.to_s],
                    ['destinataire :',destinataire],
                    ['référence offre :', reference_offre]],
                   [['référence client :', reference_client],
                    ['adresse facturation & livraison :', adresse_fl],
                    ['demandeur :', demandeur]]])


    move_down 8.mm

    contenu = [{texte: 'Référence',  largeur: 20},
               {texte: 'Article',    largeur: 40},
               {texte: 'Complément', largeur: 40},
               {texte: 'P/U HTVA',   largeur: 20},
               {texte: 'QTE',        largeur: 15},
               {texte: 'Tot HTVA',   largeur: 20},
               {texte: 'TVA',        largeur: 15}]
    tableau_ligne( contenu,
                   fill: "CFCFCF",
                   size: 8,
                   default_style: :bold )
  

    tab_commande.each do |ligne|
      contenu = [ {texte: ligne[0], largeur: 20},
                  {texte: ligne[1], largeur: 40},
                  {texte: ligne[2], largeur: 40},
                  {texte: ligne[3], largeur: 20, align: :right},
                  {texte: ligne[4], largeur: 15, align: :right},
                  {texte: ligne[5], largeur: 20, align: :right},
                  {texte: ligne[6], largeur: 15, align: :right} ]
      tableau_ligne( contenu, size: 7 )
    end


    move_down 8.mm

    tableau_ligne([{largeur: 50},
                   {texte: 'Total HTVA',  largeur: 40},
                   {texte: 'Montant TVA', largeur: 40},
                   {texte: 'Total TVAC',  largeur: 40}], 
                   fill: "CFCFCF",
                   size: 8,
                   default_style: :bold )

    contenu = [{largeur: 50},
               {texte: total_htva, largeur: 40},
               {texte: total_tva,  largeur: 40},
               {texte: total_tvac, largeur: 40}]
    tableau_ligne( contenu, 
                   size: 9,
                   default_align: :right )
    

    move_down 8.mm

    font_size 11

    mem_cursor = cursor

    text "BON POUR ACCORD", align: :right, style: :bold
    text signature, align: :right

    move_up 4.mm

    image "public/signatures/lara_croft.png", width: 50.mm, at: [13.cm, cursor]

    footer()

  end


  def deux_colonnes(tab_infos)

    min_cursor = cursor

    tab_infos[0].each do |col|
      colonne(col, 0.mm)
      move_down 4.mm
    end
    move_up 4.mm if tab_infos[0].size > 0

    max_cursor = cursor
    move_cursor_to min_cursor

    tab_infos[1].each do |col|
      colonne(col, 85.mm)
      move_down 4.mm
    end
    move_up 4.mm if tab_infos[1].size > 0

    max_cursor = cursor if cursor < max_cursor
    move_cursor_to max_cursor 

  end



  def colonne(col, x)

    min_cursor = cursor

    font_size 8
    bounding_box([bounds.left+2.mm+x,min_cursor], :width => 30.mm-4.mm) do
      text col[0], align: :right, style: :bold
    end

    max_cursor = cursor

    font_size 9
    bounding_box([bounds.left+30.mm+x+2.mm,min_cursor], :width => 55.mm-4.mm) do
      text col[1]
    end

    max_cursor = cursor if cursor < max_cursor

    move_cursor_to max_cursor

  end






end


