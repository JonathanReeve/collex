module My9sHelper
  def down_char
    "&darr;"
  end
  def up_char
    "&uarr;"
  end
  def del_char
    "&times;"
  end
  def ins_char
    "&crarr;"
  end
  def change_char
    "&Delta;"
  end
  def left_char
    "&larr;"
  end
  def right_char
    "&rarr;"
  end
  def element_bullet
    "&para;"
  end
  def opened_char
    '&#x25BC;'
  end
  def closed_char
    '&#x25B2;'
  end
  
  def element_text_thumbnail(text)
    if text == nil || text.length == 0
      return "[no text]"
    end
    
    text = strip_tags(text)
    if text.length < 30
      return text
    else
      return text[0..29] + "..."
    end
  end
  
  def element_pic_thumbnail(element, pos)
    illustrations = element.exhibit_illustrations
    if illustrations.length > pos
      element_pic_thumbnail_illustration(illustrations[pos])
    else
      "<img src='#{get_image_url(nil)}' height='16px' />"
    end
  end
  
  def get_image_url(url)
    if url == nil || url.length == 0
      return DEFAULT_THUMBNAIL_IMAGE_PATH
    end
    return url
  end
  
  def element_pic_thumbnail_illustration(illustration)
    if illustration.illustration_type == ExhibitIllustration.get_illustration_type_image()
      "<img src='#{get_image_url(illustration.image_url)}' height='16px' />"
    elsif illustration.illustration_type == ExhibitIllustration.get_illustration_type_nines_obj()
      thumb = CachedResource.get_thumbnail_from_uri(illustration.nines_object_uri)
      "<img src='#{get_image_url(thumb)}' height='16px' />"
    elsif illustration.illustration_type == ExhibitIllustration.get_illustration_type_text()
      "..."
    end
  end

  def tree_node( page_num, item_id_prefix, class_name, toggle_function, exhibit_id, num_pages, initial_state )
    display_none = 'style="display:none"'
    label = ""
    if num_pages > 1  # We don't want any page controls if there is only one page.
      label << "<div class='outline_right_controls'>\n"
      if page_num.to_i > 1
        label << link_to_function(up_char(), "doAjaxLinkOnPage('move_page_up', #{exhibit_id}, #{page_num} );", { :title => 'Move Page Up', :class => 'modify_link' }) + "\n"
      end
      if page_num.to_i < num_pages
        label << link_to_function(down_char(), "doAjaxLinkOnPage('move_page_down', #{exhibit_id}, #{page_num} );", { :title => 'Move Page Down', :class => 'modify_link' }) +"\n"
      end
      label << '&nbsp;<span class="close_link">'
      label << link_to_function(del_char(), "doAjaxLinkOnPage('delete_page', #{exhibit_id}, #{page_num} );", { :title => 'Delete Page', :class => 'modify_link' })
      label << "</span>\n"
      label << "</div>\n"
    end
    
    label << "<span id=\"#{item_id_prefix}_p#{page_num}_closed\" #{initial_state == :open ? display_none : ''} >"
    label << link_to_function(closed_char(),"#{toggle_function}('#{item_id_prefix}_p#{page_num}')", { :class => 'modify_link' })
    label << "</span>\n"
    label << "<span id=\"#{item_id_prefix}_p#{page_num}_opened\" #{initial_state == :closed ? display_none : ''} >"
    label << link_to_function(opened_char(), "#{toggle_function}('#{item_id_prefix}_p#{page_num}')", { :class => 'modify_link'})
    label << "</span>\n"
    label << "<span class='#{class_name}'>" + "Page " + page_num + "</span>\n"
  end  
  
  def create_border_div(element, border_active, border_class)
    # This creates either an open div tag with a border, nothing, or a close div tag .
    # If this is the first element in a section, then is_first is returned true .
    close_div = "</div>\n"
    open_div = "<div class='#{border_class}'>\n"
    border_type = element.get_border_type()
    if border_type == "start_border" && border_active == true
      html = close_div + open_div
      border_active = true
      #is_first = true
    elsif border_type == "start_border" && border_active == false
      html = open_div
      border_active = true
      #is_first = true
    elsif border_type == "continue_border" && border_active == true
      html = ""
      border_active = true
      #is_first = false
    elsif border_type == "continue_border" && border_active == false
      html = open_div
      border_active = true
      #is_first = true
    elsif border_type == "no_border" && border_active == true
      html = close_div
      border_active = false
      #is_first = true
    elsif border_type == "no_border" && border_active == false
      html = ""
      border_active = false
      #is_first = true
    end
    
    return { :border_active => border_active, :html => html };
  end
end
