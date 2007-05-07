class ExhibitedSectionsController < ExhibitsBaseController
  prepend_before_filter :authorize, :only => [:create, :new, :edit, :update, :destroy, :move_higher, :move_lower, :move_to_top, :move_to_bottom]
  before_filter :authorize_owner, :only => [:edit, :update, :destroy, :move_higher, :move_lower, :move_to_top, :move_to_bottom]
  
  in_place_edit_for_resource :exhibited_section, :title
  in_place_edit_for_resource :exhibited_section, :annotation

  def move_higher
    move_item(:move_higher, "Moved Exhibited Section Up.")
  end  
  def move_lower
    move_item(:move_lower, "Moved Exhibited Section Down.")
  end  
  def move_to_top
    move_item(:move_to_top, "Moved Exhibited Section to Top.")
  end  
  def move_to_bottom
    move_item(:move_to_bottom, "Moved Exhibited Section to Bottom.")
  end
  def move_item(command, notice)
    @exhibited_section = ExhibitedSection.find(params[:id])
    @exhibited_section.__send__(command)
    logger.info("ExhibitedSection: #{command.to_s}: #{params[:id]}")
    flash[:notice] = notice
    page = params[:page] || 1
    redirect_to edit_exhibit_path(:id => params[:exhibit_id], :anchor => dom_id(@exhibited_section), :page => page)
  rescue
    logger.info("Error: #{command} with id=#{params[:id]} failed.")
    flash[:error] = "There was an error moving your section."
    redirect_to edit_exhibit_path(:id => params[:exhibit_id], :page => page)
  end
  private :move_item  

  def create
    @exhibit = Exhibit.find(params[:exhibit_id])
    respond_to do |format|
      if @exhibit.exhibited_sections << ExhibitedSection.new(:exhibit_section_type_id => params[:exhibit_section_type_id])
        @exhibit.exhibited_sections.last.move_to_top
        flash[:notice] = 'A new Exhibited Section was successfully added.'
        format.html { redirect_to edit_exhibit_url(:id => @exhibit) }
        format.xml  { head :ok }
      else
        format.html do
          flash[:error] = "There was a problem creating a new Exibited Section."
          redirect_to edit_exhibit_url(@exhibit)
        end
        format.xml  { render :xml => @exhibited_section.errors.to_xml }
      end
    end
    
  end
  
  def update
    @exhibited_section = ExhibitedSection.find(params[:id])
    @exhibit = Exhibit.find(params[:exhibit_id])

    respond_to do |format|
      if @exhibited_section.update_attributes(params[:exhibited_section])
        flash[:notice] = 'Exhibited Section was successfully updated.'
        format.html { redirect_to edit_exhibit_url(:id => @exhibit, :anchor => dom_id(@exhibited_section)) }
        format.xml  { head :ok }
      else
        format.html { redirect_to edit_exhibit_url(@exhibit) }
        format.xml  { render :xml => @exhibited_section.errors.to_xml }
      end
    end
  end
  
  def destroy
    @exhibited_section = ExhibitedSection.find(params[:id])
    @exhibit = Exhibit.find(params[:exhibit_id])
    @exhibited_section.destroy

    respond_to do |format|
      flash[:notice] = 'Exhibited Section was successfully removed.'
      format.html { redirect_to edit_exhibit_url(@exhibit) }
      format.xml  { head :ok }
    end
  end
end
