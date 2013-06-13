class GoogleDriveController < ApplicationController

  before_filter :authenticate_user!
  
  def dump
    authorize! :google_drive, :dump
  end
  
#   
#   def import
#     
#     authorize! :google_drive, :import
#      
#     require "rubygems"
#     require "google_drive"
# 
#     redirect_to :google_drive_import, :notice => 'import complete'
#     
#   end
#   
  
  def read
    authorize! :google_drive, :read
    redirect_to :google_drive_import, :alert => 'Import TODO.'
  end
  
#   
#   def write
#     
#     authorize! :google_drive, :write
#     
#     require "rubygems"
#     require "google_drive"
# 
#     date = DateTime.now
# 
#     session = GoogleDrive.login(params[:google_username], params[:google_password])
#     
#     unless params[:spreadsheet_key].empty?
#       spreadsheet = session.spreadsheet_by_key(params[:spreadsheet_key])
#     else
#       spreadsheet = session.create_spreadsheet("materiel040 #{date.year}-#{date.month}-#{date.day} #{date.hour}:#{date.minute}:#{date.second}")
#     end
# 
#     ws = spreadsheet.worksheets[0]
#     ws.title = "dump"
#     ws[1,1] = "datetime"
#     ws[1,2] = date
#     ws[2,1] = "user"
#     ws[2,2] = current_user.email
#     ws[3,1] = "ip"
#     ws[3,2] = current_user.current_sign_in_ip
#     ws.save()
#     ws.reload()
#     
#     
#     ActiveRecord::Base.send(:subclasses).each do |objet|
#     #[Category,Container,Content,Item,User].each do |objet|
#     
#       ws = spreadsheet.add_worksheet(objet.to_s)
#       
#       i = 1
#       j = 0
#       objet.attribute_names.each do |attr_name|
#         j += 1
#         ws[1, j] = attr_name
#       end
# 
#       objet.all.each do |item|
#         i += 1
#         j = 0
#         objet.attribute_names.each do |attr_name|
#           j += 1
#           ws[i, j] = item[attr_name.to_sym]
#         end
#       end
# 
#       ws.save()
#       ws.reload()
#       
#     end
# 
#     redirect_to :google_drive_dump, :notice => 'dump complete'
#   end
  
end
