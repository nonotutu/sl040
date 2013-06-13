#encoding: utf-8

class PdfInventaire < Pdf

  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

  # 
    
  
  def titre_inventaire(container)
  
    pos = cursor - 4.mm

    font "DejaVuSans"

#     font_size 12
#     
#     bounding_box([bounds.left,pos], :width => 1.cm, :height => 11.5.mm-4.mm) do
#       text "#{page_number} / #{page_count}", :align => :left
#     end
    
    font_size 20

    bounding_box([bounds.left+2.cm+2.mm,pos+2.mm], :width => 13.cm-4.mm, :height => 11.5.mm-4.mm) do
      text "─ #{container.name} ─", :align => :left
    end

    bounding_box([bounds.left+15.cm+2.mm,pos+2.mm], :width => 4.cm-4.mm, :height => 11.5.mm-4.mm) do
      text container.short_name, :align => :center, :style => :bold
    end

    stroke_rectangle [bounds.left+15.cm,pos+4.mm], 4.cm, 10.mm

    move_down 8.mm

  end

  
  def content(container)
    
    contenu = container.contenu

    font "DejaVuSansCondensed"
    font_size_item = 8
    font_size_container = 9
    hauteur = 3.5.mm
    hauteur_ligne_container = 4.mm
    decal_rect = 0.5.mm
    decal_indent = 0.5.cm
    largeur = 19.cm
    col1 = 7.5.cm
    col2 = 6.5.cm
    col3 = 4.cm
    col4 = 1.cm
    bi = 0

#     stroke_line( [bounds.left, 0],[bounds.right, 0])
#     stroke_line( [bounds.left, hauteur],[bounds.right, hauteur])
#     stroke_line( [bounds.left, hauteur * 2],[bounds.right, hauteur * 2])
#     stroke_line( [bounds.left, hauteur * 3],[bounds.right, hauteur * 3])
    
    contenu.each do |cont|
      if cont[1].is_a?(Container)
        if ( ( cont[1].contents.count * hauteur ) >= ( cursor ) )
          start_new_page
          titre_inventaire(container)
        end
        font_size font_size_container
        if cont[1] == contenu[0][1]
          fill_color "000000"
        else
          fill_color "7F7F7F"
        end
        fill_rectangle [bounds.left+cont[0]*decal_indent,cursor+decal_rect], largeur-cont[0]*decal_indent, hauteur_ligne_container
        fill_color "FFFFFF"
        bounding_box([bounds.left+2.mm+cont[0]*decal_indent,cursor], :width => col1-cont[0]*decal_indent-4.mm, :height => hauteur_ligne_container) do
          text cont[1].name, :style => :bold
        end
        move_up(hauteur_ligne_container)
        bounding_box([bounds.left+2.mm+col1,cursor], :width => col2+col3-4.mm, :height => hauteur_ligne_container) do
          text cont[1].model
        end
        if cont[1] != contenu[0][1] && cont[1].quantity > 1
          move_up(hauteur_ligne_container)
          bounding_box([bounds.left+2.mm+col1+col2+col3,cursor], :width => col4-4.mm, :height => hauteur_ligne_container) do
            text "× #{cont[1].quantity.to_s}", :align => :right, :style => :bold
          end
        end
        bi = 0
      elsif cont[1].is_a?(Content)
        font_size font_size_item
        bi += 1
        if bi%2 == 0
          fill_color "EEEEEE"
        else
          fill_color "FFFFFF"
        end
        fill_rectangle [bounds.left+cont[0]*decal_indent,cursor+decal_rect], largeur-cont[0]*decal_indent, hauteur
        stroke_line    [bounds.left+cont[0]*decal_indent,cursor+decal_rect], [bounds.left+cont[0]*decal_indent,cursor-hauteur]
        fill_color "000000"
        bounding_box([bounds.left+2.mm+cont[0]*decal_indent,cursor], :width => col1-cont[0]*decal_indent-4.mm, :height => hauteur) do
          text cont[1].item.nature
        end
        if cont[1].item.disposable
          move_up(hauteur)
          bounding_box([bounds.left+col1-2.mm,cursor], :width => 3.mm, :height => hauteur) do
            text "⊘"
          end
        end
        move_up(hauteur)
        bounding_box([bounds.left+2.mm+col1,cursor], :width => col2-4.mm, :height => hauteur) do
          text cont[1].item.produit
        end
        unless cont[1].unitary
          move_up(hauteur)
          bounding_box([bounds.left+2.mm+col1+col2,cursor], :width => col3-4.mm, :height => hauteur) do
            text cont[1].item.condition
          end
        end
        move_up(hauteur)
        bounding_box([bounds.left+2.mm+col1+col2+col3,cursor], :width => col4-4.mm, :height => hauteur) do
          text cont[1].quantity.to_s, :align => :right
        end
      end
    end
    
  end
  
end
