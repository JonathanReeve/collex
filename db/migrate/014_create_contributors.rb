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

class CreateContributors < ActiveRecord::Migration
  def self.up
    create_table :contributors do |t|
      t.column :archive_name,	:string, :null => false
      t.column :email,			:string, :null => false
      t.column :contact,		:string, :null => false
    end
  end

  def self.down
  	drop_table :contributors
  end
end
