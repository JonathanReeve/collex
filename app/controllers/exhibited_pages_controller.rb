##########################################################################
# Copyright 2007 Applied Research in Patacriticism and the University of Virginia
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

class ExhibitedPagesController < ExhibitsBaseController
  layout "collex"
  helper ExhibitsHelper
  before_filter :authorize_owner, :except => [:show, :creative_commons]
  
  uses_tiny_mce(:options => {
                  :browsers => "msie,gecko,opera",
                  :editor_selector => "tiny-mce",
                  :theme => "advanced", 
                  :theme_advanced_toolbar_location => "top",
                  :theme_advanced_toolbar_align => "left",
                  :theme_advanced_resizing => true,
                  :plugins => ["preview", "save"],
                  :theme_advanced_buttons1 => "bold,italic,underline,separator,preview,separator,outdent,indent,unlink,link,separator,undo,redo,separator,cleanup,code,help,save",
                  :theme_advanced_buttons2 => "",
                  :theme_advanced_buttons3 => "",
                  :save_enablewhendirty => true,
                  :entity_encoding => "raw"
                },
                :only => [:edit])
  
  in_place_edit_for_resource :exhibited_page, :title
  in_place_edit_for_resource :exhibited_page, :annotation

  def move_higher
    move_item(:move_higher, "Moved Page Up.")
  end  
  def move_lower
    move_item(:move_lower, "Moved Page Down.")
  end  
  def move_to_top
    move_item(:move_to_top, "Moved Page to Top.")
  end  
  def move_to_bottom
    move_item(:move_to_bottom, "Moved Page to Bottom.")
  end
  def move_item(command, notice)
    @exhibited_page = @exhibit.exhibited_pages.find(params[:id])
    @exhibited_page.__send__(command)
    logger.info("ExhibitedPage: #{command.to_s}: #{params[:id]}")
    flash[:notice] = notice
    redirect_to edit_page_path(:id => @exhibited_page, :exhibit_id => @exhibit)
  rescue Exception => e
    logger.info("Error: #{command} with id=#{params[:id]} failed with #{e}")
    flash[:error] = "There was an error moving your page."
    redirect_to edit_page_path(:id => @exhibited_page, :exhibit_id => @exhibit)
  end
  private :move_item
  
  # Note @exhibit is populated in ExhibitsBaseController except for index
  def index
    @exhibit = Exhibit.find(params[:exhibit_id])
    @exhibited_pages = @exhibit.exhibited_pages
  end

  def show
    @exhibited_page = @exhibit.exhibited_pages.find(params[:id])
  end

  def edit
    @exhibited_page = @exhibit.exhibited_pages.find(params[:id])
    @licenses = License.find(:all)    
    @section_types =  ExhibitPageType.find(@exhibited_page.exhibit_page_type_id).section_types
  end

  def new
  end
  
  def creative_commons
    license_url = params[:license_url]
    license_name = params[:license_name]
    license_button = params[:license_button]
    logger.debug("license_url: #{license_url}")
    logger.debug("license_name: #{license_name}")
    logger.debug("license_button: #{license_button}")
    @license = License.find_by_url(license_url) || License.create(:name => license_name, :url => license_url, :button_url => license_button)
    render :layout => false
  end
  
  # Note, just have one page type per exhibit right now, so grab the first
  def create
#     @exhibit = Exhibit.find(params[:exhibit_id])
    flash[:notice] = 'Page was successfully created.'
    page_type = @exhibit.valid_page_types.first
    if @page = @exhibit.pages.create({:exhibit_page_type_id => page_type.id})
      # if the page type has only one section type, go ahead and create it
      if page_type.section_types.size == 1
        @page.sections.create({:exhibit_section_type_id => page_type.section_types.first.id})
      end
      flash[:notice] = 'Page was successfully created.'
      redirect_to edit_page_path(:id => @page, :exhibit_id => @exhibit)
    else
      flash[:error] = 'There was an error creating the new page.'
      redirect_to edit_page_path(:id => params[:page_id], :exhibit_id => @exhibit)
    end
  end
  
  def destroy
    @exhibited_page = ExhibitedPage.find(params[:id])
    if(@exhibit.pages.count <= 1)
      flash[:error] = "This is your only page, so it can not be removed."
      redirect_to edit_page_path(@exhibit, @exhibited_page)
    else
      @exhibited_page.destroy
      flash[:notice] = "Your Page was deleted successfully."
      redirect_to edit_page_path(@exhibit, @exhibit.pages.first)
    end
  end
end
