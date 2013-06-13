#encoding: utf-8

class Pdf < Prawn::Document

  def registering_police_dejavusanscondensed
    font_families.update("DejaVuSansCondensed" => {:normal      => "public/fonts/DejaVuSansCondensed.ttf",
                                                   :italic      => "public/fonts/DejaVuSansCondensed-Oblique.ttf",
                                                   :bold        => "public/fonts/DejaVuSansCondensed-Bold.ttf",
                                                   :bold_italic => "public/fonts/DejaVuSansCondensed-BoldOblique.ttf"
                                                  })
  end

  def registering_police_dejavusansmono
    font_families.update("DejaVuSansMono" => {:normal      => "public/fonts/DejaVuSansMono.ttf",
                                              :italic      => "public/fonts/DejaVuSansMono-Oblique.ttf",
                                              :bold        => "public/fonts/DejaVuSansMono-Bold.ttf",
                                              :bold_italic => "public/fonts/DejaVuSansMono-BoldOblique.ttf"
                                             })
  end

  def registering_police_dejavusans
    font_families.update("DejaVuSans" => {:normal      => "public/fonts/DejaVuSans.ttf",
                                          :italic      => "public/fonts/DejaVuSans-Oblique.ttf",
                                          :bold        => "public/fonts/DejaVuSans-Bold.ttf",
                                          :bold_italic => "public/fonts/DejaVuSans-BoldOblique.ttf"
                                         })
  end


  
  def header(department_id = nil)

    bounding_box([bounds.left-8.mm,bounds.top+10.mm], :width => bounds.right-bounds.left+16.mm, :height => 17.mm) do
      
      font_size 8
      text "Croix-Rouge de Belgique"
      
      department = begin Department.find(department_id) rescue nil end

      if department.nil?
        text "Section locale d'Uccle", style: :bold
      else
        text "Section locale d'Uccle"
        text department.name, :style => :bold
      end
      
      text "96 rue de Stalle"
      text "1180 Uccle"

      move_cursor_to bounds.top
      image "public/icons/logo_2293-563.png", :height => 14.mm, :position => :right
      
      move_cursor_to bounds.bottom
      stroke_line [bounds.left-2.mm,cursor-2.mm],[bounds.right+2.mm,cursor-2.mm]
      move_down 2.mm
      
    end
    
  end

  

  def cadre_adresse(adresse)

    bounding_box([bounds.left+85.mm,cursor], :width => bounds.right-bounds.left-85.mm) do
      bounding_box([bounds.left+2.mm,bounds.top-2.mm], :width => 81.mm) do
        font_size 11
        text "#{adresse}"
      end
      move_down 1.mm
      line_width 1
      stroke_bounds
    end
    
  end


  
  def lieu_date(lieu, date)
  
    date = DateTime.now if date == ''
    date = date.to_s #(:cust_ddMMMMyyyy)

    font_size 11
    text "#{lieu}, #{date}", :align => :right
    
  end
  
  
  
  def titre(titre)

    font_size 20
    
    bounding_box([bounds.left,cursor], :width => 170.mm) do
      stroke_horizontal_rule
      move_down 2.mm
      text "#{titre}", align: :center, style: :bold
      stroke_horizontal_rule
    end
    
  end


  
  def info(titre, contenu)

    font_size 9
    
    bounding_box([bounds.left,cursor], :width => 40.mm, :height => 4.mm) do
      text "#{titre} :", :align => :right
    end

    font_size 11

    bounding_box([bounds.left+44.mm,cursor+4.mm], :width => 126.mm) do
      text contenu
    end
            
  end



  def footer(categ = nil)
    
    bounding_box([bounds.left-8.mm,bounds.bottom], :width => bounds.right-bounds.left+16.mm, :height => 8.mm) do
      
      define_grid(:columns => 13, :rows => 5, :column_gutter => 4)
      
      font_size 8
      
      # grid([1,0], [2,0]).bounding_box do
      #   text "tel :", :align => :right
      # end
      # grid([3,0], [4,0]).bounding_box do
      #   text "e-mail :", :align => :right
      # end
     
      # grid([1,1], [2,5]).bounding_box do
      #   text "+ 32 (0) 477 931 255"
      # end
      # grid([3,1], [4,5]).bounding_box do
      #   text "secours@croix-rouge-uccle.be"
      # end

      grid([1,7], [2,12]).bounding_box do
        text "Banque ING :  IBAN BE90 3100 0858 8832", :align => :right
      end
      grid([3,7], [4,12]).bounding_box do
        text "Swift BBRUBEBB", :align => :right
      end
      
      move_cursor_to bounds.top
      stroke_line [bounds.left-2.mm,cursor+2.mm],[bounds.right+2.mm,cursor+2.mm]
      
    end
    
  end
 


  def tableau_ligne(tab, size: 8, fill: nil, default_style: nil, default_align: :left, lignes_horizontales: true)

    font_size size

    cursor_min = cursor
    cursor_max = cursor
    xx = 0

    tab.each do |l|
      bounding_box([bounds.left+xx.mm+1.mm,cursor_min], :width => l[:largeur].mm-2.mm) do
        align = default_align
        align = l[:align] if l[:align]
        style = default_style
        style = l[:style] if l[:style]
        text l[:texte], style: style, align: align if l[:texte]
      end
      xx += l[:largeur]
      cursor_max = cursor if cursor < cursor_max
    end

    unless fill.nil?

      fill_color fill

      xx = 0
      tab.each do |l|
        fill_rectangle [xx.mm, cursor_min+1.mm], l[:largeur].mm, cursor_min - cursor_max + 1.mm if l[:texte]
        xx += l[:largeur]
      end
      
      fill_color "000000"

      xx = 0
      tab.each do |l|
        bounding_box([bounds.left+xx.mm+1.mm,cursor_min], :width => l[:largeur].mm-2.mm) do 
          align = default_align
          align = l[:align] if l[:align]
          style = default_style
          style = l[:style] if l[:style]
          text l[:texte], style: style, align: align if l[:texte]
        end
        xx += l[:largeur]
      end    

    end

    xx = 0
    tab.each do |l|
      if l[:texte]
        line_width 0.2
        stroke_line [bounds.left+xx.mm, cursor_min+1.mm], [bounds.left+xx.mm, cursor_max]
        if lignes_horizontales
          line_width 1
          stroke_line [xx.mm,cursor_min+1.mm], [xx.mm+l[:largeur].mm,cursor_min+1.mm]
          stroke_line [xx.mm,cursor_max], [xx.mm+l[:largeur].mm,cursor_max]
        end
      end
      xx += l[:largeur]
    end
    line_width 0.2
    stroke_line [bounds.left+xx.mm, cursor_min+1.mm], [bounds.left+xx.mm, cursor_max]

    move_cursor_to cursor_max - 1.mm

  end



end