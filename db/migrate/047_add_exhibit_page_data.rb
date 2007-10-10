##########################################################################
# Copyright 2007 Applied Research in Patacriticism
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

class AddExhibitPageData < ActiveRecord::Migration
  class ExhibitPageType < ActiveRecord::Base
  end
  
  def self.up
    ExhibitPageType.destroy([1,2]) rescue nil
    @ept = ExhibitPageType.new do |ept|
      ept.id = 1
      ept.name = "Annotated Bibliography Page Type"
      ept.description = "Annotated Bibliography pages have one section per page."
      ept.template = "base_page"
      ept.min_sections = 1
      ept.max_sections = 1
      ept.exhibit_type_id = 2
    end
    @ept.save!
    
    @ept = ExhibitPageType.new do |ept|
      ept.id = 2
      ept.name = "Illustrated Essay Page Type"
      ept.description = "Illustrated Essay pages can have 100 sections per page."
      ept.template = "base_page"
      ept.min_sections = 1
      ept.max_sections = 100
      ept.exhibit_type_id = 3
    end
    @ept.save!
  end

  def self.down
    ExhibitPageType.destroy([1,2])
  end
end
