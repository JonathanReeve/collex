##########################################################################
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################

class CreateExhibitTypeDetails < ActiveRecord::Migration
  def self.up
    create_table :section_types do |t|
      t.column :description, :string
    end
    
    create_table :exhibit_types_section_types do |t|
      t.column :exhibit_type_id, :integer
      t.column :section_type_id, :integer
    end
    
    create_table :panel_types do |t|
      t.column :description, :string
    end
    
    create_table :panel_types_section_types do |t|
      t.column :panel_type_id, :integer
      t.column :section_type_id, :integer
    end
    
  end

  def self.down
    drop_table :section_types
    drop_table :panel_types
    drop_table :exhibit_types_section_types
    drop_table :panel_types_section_types
  end
end
