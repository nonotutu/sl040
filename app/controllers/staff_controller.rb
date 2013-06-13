#coding: utf-8
class StaffController < InheritedResources::Base  
  
  before_filter :authenticate_user!
  
  def index
    authorize! :staff, :index
    @last_update = [Volunteer.unscoped.order(:updated_at).last.updated_at,Volunteer.unscoped.order(:created_at).last.created_at].max
    @last_update = @last_update.to_s + " - " + (Date.today - @last_update.to_date).to_i.to_s + " days ago"
    @next_birthdays = []
    today = Date.today
    annifs = []
    Volunteer.order(:date_of_birth).each do |volunteer| #.only_active
      if annif = volunteer.next_birthday_on
        annifs << { date: annif, name: volunteer.to_long_s, active: volunteer.active? }
      end
    end
    annifs.each do |annif|
      if annif[:date].in?(today-1.day..(today+2.month))
        @next_birthdays << annif #{:date => annif[:date], :name => annif[:name], :active => annif[:active]}
      end
    end
      @next_birthdays = @next_birthdays.sort_by { |nb| nb[:date] }
  end
  
  
  def table_volunteers_trainings

    authorize! :staff, :table_volunteers_trainings

    row = []
    Training.all.each do |training|
      row << training
    end
    
    @trainings_names = row

    @table = []
    Volunteer.only_active.each do |volunteer|
      row = [volunteer]
      Training.all.each do |training|
        if volunteer.trainings.include?(training)
          row << Certificate.where(:training_id => training, :volunteer_id => volunteer)
        else
          row << training.id
        end
      end
      @table << row
    end
    
  end
  
  
  def volunteers_to_google_drive

    authorize! :staff, :export
        
    require "rubygems"
    require "google_drive"

    if params[:volunteers_ids]
      volunteers_ids = params[:volunteers_ids]
    else
      volunteers_ids = Volunteer.select(:id)
    end
    
    date = DateTime.now

#     session = GoogleDrive.login(params[:google_username], params[:google_password])
#     session = GoogleDrive.login('arnaud.attout@gmail.com', 'meeukadztjmzeojn')
    session = GoogleDrive.login(current_user.email, current_user.google_drive_password)

    spreadsheet = session.create_spreadsheet("extraction volontaires #{date.year}-#{date.month}-#{date.day} #{date.hour}:#{date.minute}:#{date.second}")

    ws = spreadsheet.worksheets[0]
    ws.title = "infos"
    ws[1,1] = "datetime"
    ws[1,2] = date
    ws[2,1] = "user"
    ws[2,2] = current_user.email
    ws[3,1] = "ip"
    ws[3,2] = current_user.current_sign_in_ip
    
    row = 5
    ws[row,1] = "Services"
    Department.all.each do |department|
      row += 1
      ws[row,1] = department.short_name
      ws[row,2] = department.name
    end
    
    ws.save()
    ws.reload()
    
    ws = spreadsheet.add_worksheet("volontaires")

    i = 1
    ws[i,1]  = "matricule"
    ws[i,2]  = "titre"
    ws[i,3]  = "nom"
    ws[i,4]  = "prénom"
    ws[i,5]  = "sx"
    ws[i,6]  = "né(e) le"
    ws[i,7]  = "né(e) à"
    ws[i,8]  = "adresse"
    ws[i,9]  = "entré(e) le"
    ws[i,10] = "état"
    ws[i,11] = "gsm"
    ws[i,12] = "email"
    ws[i,13] = "banque"
    ws[i,14] = "services"
    
    volunteers_ids.each do |volunteer_id|
      volunteer = Volunteer.find(volunteer_id)
      i += 1
      ws[i,1]  = volunteer.cr_number
      ws[i,2]  = volunteer.sex == 1 ? "Madame" : (volunteer.sex == 2 ? "Monsieur" : "")
      ws[i,3]  = volunteer.last_name
      ws[i,4]  = volunteer.first_name
      ws[i,5]  = volunteer.sex == 1 ? "F" : (volunteer.sex == 2 ? "M" : "")
      ws[i,6]  = volunteer.date_of_birth
      ws[i,7]  = volunteer.place_of_birth
      ws[i,8]  = volunteer.address
      ws[i,9]  = volunteer.cr_joined_on
      ws[i,10] = volunteer.department_ids.empty? ? "inactif" : "actif"
      ws[i,11] = volunteer.cell_phone
      ws[i,12] = volunteer.email
      ws[i,13] = volunteer.bank_account
      deps = ""
      volunteer.department_ids.each do |department_id|
        deps += Department.find(department_id).short_name
        deps += " ; "
      end
      ws[i,14] = deps
    end

    ws.save()
    ws.reload()
      
    redirect_to :back, :notice => 'Dump complete.'
    
  end

  
  protected

  def volunteers_to_csv(volunteers)

    authorize! :staff, :export
    
    volunteers = Volunteer.only_active unless volunteers
    csv_string = CSV.generate do |csv|
      csv << ["Name", "Given Name", "Family Name", "Birthday", "Group Membership", "E-mail 1 - Type", "E-mail 1 - Value", "Phone 1 - Type", "Phone 1 - Value"]
      volunteers.each do |v|
        temp1 = ["#{v.first_name} #{v.last_name}", v.first_name, v.last_name, v.date_of_birth]
        temp2 = ""
        v.departments.each do |d|
          temp2 += "CRB040 #{d.short_name} ::: "
        end
        temp2 = [temp2[0..temp2.length-6]]
        temp3 = ["Home", v.email, "Mobile", v.cell_phone]
        csv << temp1 + temp2 + temp3
      end
    end
    csv_string
  end
    
end
