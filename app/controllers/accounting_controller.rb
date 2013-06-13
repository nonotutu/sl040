#coding: utf-8
class AccountingController < InheritedResources::Base
 
  include NumberHelper

  before_filter :authenticate_user!

  
  def index
    #authorize! :accounting, :index
  end


  def generate_accdoc_from_scratch # TODO: localisation temporaire

    department_id = params[:department][:id].to_i

    adresse = params[:adresse].blank? ? adresse = "<adresse>" : params[:adresse]
    lieu    = params[:lieu].blank?    ? lieu    = "Uccle"     : params[:lieu]

    params[:date] = "#{params['date']['(1i)']}-#{params['date']['(2i)']}-#{params['date']['(3i)']}"
    date = begin params[:date].to_date rescue Date.today end

    type    = params[:type].blank? ?    type    = 'devis'     : params[:type]
    numero  = params[:numero]

    params[:date_rappel_0] = "#{params['date_rappel_0']['(1i)']}-#{params['date_rappel_0']['(2i)']}-#{params['date_rappel_0']['(3i)']}"
    date_rappel_0 = begin params[:date_rappel_0].to_date rescue Date.today end
    params[:date_rappel_1] = "#{params['date_rappel_1']['(1i)']}-#{params['date_rappel_1']['(2i)']}-#{params['date_rappel_1']['(3i)']}"
    date_rappel_1 = begin params[:date_rappel_1].to_date rescue Date.today end
    params[:date_rappel_2] = "#{params['date_rappel_2']['(1i)']}-#{params['date_rappel_2']['(2i)']}-#{params['date_rappel_2']['(3i)']}"
    date_rappel_2 = begin params[:date_rappel_2].to_date rescue Date.today end
    
    
    reference = params[:reference]

    tab_infos = []
    unless params[:evt_nom].blank?
      tab_infos << ["Événement", params[:evt_nom]]
    end
    unless params[:evt_dh].blank?
      tab_infos << ["Dates & heures", params[:evt_dh]]
    end
    unless params[:evt_lieu].blank?
      tab_infos << ["Lieu", params[:evt_lieu]]
    end

    contact = params[:contact]

    invoice_items = []

    4.times do |i|

      name = params['name'+i.to_s]
      price = params['price'+i.to_s].to_f != 0 ? params['price'+i.to_s].to_f : 1 ## TODO : et si 0 ?
      kind = params['kind'+i.to_s] == "pourcent" ? 2 : 1
      qty = params['qty'+i.to_s].to_f > 0 ? params['qty'+i.to_s].to_f : 1

      if name != ""
        invoice_items << [ name, price, kind, qty ]
      end

    end

    tab_facture = []
    total = BigDecimal.new("0.0")

    invoice_items.each do |ii|

      if ii[2] == 2
        tab_facture << [ ii[0], "", to_percent(ii[1]), to_euro(total * ii[1]/100) ]
        total += total * (ii[1]/100.0)
      else
        tab_facture << [ ii[0], ii[3].to_s, to_euro(ii[1]), to_euro(ii[3] * ii[1]) ]
        total += ii[3] * ii[1]
      end

    end

    # render text: department_id

    pdf = FacturePdf.new(department_id,
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
                         to_euro(total),
                         contact
                         )
    send_data pdf.render, filename: "facture.pdf", type: "application/pdf"
  end



  def generate_bdc_from_scratch # TODO: localisation temporaire

    department_id = params[:department][:id].to_i

    params[:date] = "#{params['date']['(1i)']}-#{params['date']['(2i)']}-#{params['date']['(3i)']}"
    date = begin params[:date].to_date rescue Date.today end

    destinataire     = params[:destinataire].blank?     ? "<aucun>"  : params[:destinataire]
    reference_offre  = params[:reference_offre].blank?  ? "<aucune>" : params[:reference_offre]
    reference_client = params[:reference_client].blank? ? "<aucune>" : params[:reference_client]
    adresse_fl       = params[:adresse_fl].blank?       ? "<aucune>" : params[:adresse_fl]
    demandeur        = params[:demandeur].blank?        ? "<aucune>" : params[:demandeur]
    signature        = params[:signature].blank?        ? "<aucune>" : params[:signature]

    tab_items = []

    8.times do |i|

      ref = params['ref'+i.to_s]
      art = params['art'+i.to_s]
      cpl = params['cpl'+i.to_s]
      price = params['price'+i.to_s].to_f
      qty = params['qty'+i.to_s].to_f
      tva = params['tva'].blank? ? 21.0 : params['tva'].to_f

      unless ref.blank? && art.blank? && cpl.blank? 
        tab_items << [ ref, art, cpl, price, qty, tva ]
      end

    end

    tab_commande = []
    total_htva = BigDecimal.new("0.0")
    total_tva = BigDecimal.new("0.0")
    total_tvac = BigDecimal.new("0.0")

    tab_items.each do |i|

      tab_commande << [ i[0], i[1], i[2], to_euro(i[3]), i[4].to_s, to_euro((i[3]*i[4])), to_percent(i[5]) ]
      total_htva += i[3] * i[4]
      total_tva += ( i[3] * i[4] ) * ( i[5] / 100 )
      total_tvac += ( ( i[3] * i[4] ) * ( ( i[5] / 100 ) + 1 ) )

    end

    pdf = BonDeCommandePdf.new(department_id,
                               date,
                               destinataire,
                               reference_offre,
                               reference_client,
                               adresse_fl,
                               demandeur,
                               tab_commande,
                               to_euro(total_htva),
                               to_euro(total_tva),
                               to_euro(total_tvac),
                               signature
                               )
    send_data pdf.render, filename: "bon de commande.pdf", type: "application/pdf"
  
  end


end