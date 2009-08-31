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

require File.dirname(__FILE__) + '/../test_helper'

class SiteTest < ActiveSupport::TestCase
  fixtures :sites

  def test_thumbnails_returns_a_list_of_available_site_thumbnail_urls
    assert_equal(9, Site.find(:all).size)
    assert_equal(['http://www.personal.psu.edu/faculty/c/a/caw43/bierce/main.gif', 'http://www.rc.umd.edu/images/nhead_01.jpg'], Site.thumbnails)
  end
  
  def test_thumbnails_for_codes_returns_a_list_of_thumbnails_for_listed_sitenames
    assert_equal(["http://www.personal.psu.edu/faculty/c/a/caw43/bierce/main.gif"], Site.thumbnails_for_codes(['bierce']))
  end
end
