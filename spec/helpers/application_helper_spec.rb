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

require File.dirname(__FILE__) + '/../spec_helper'


describe ApplicationHelper do
  before(:each) do
    @uri = 'http://test/uri'
    @item = {'uri' => @uri}
    @er = mock_model(ExhibitedResource)
    @generic_site = mock_model(Site, :thumbnail => '')
    @specific_site = mock_model(Site, :thumbnail => 'http://some.site.url.com/image.gif', :description => 'Site Description')
  end


  it "'thumbnail_image' shoud get generic image when no others" do  
    Site.should_receive(:find_by_code).with('generic').and_return(@generic_site)
    item = @item.merge({'archive' => 'generic', 'title' => 'The Generic'})
    expected = %(<img src="#{DEFAULT_THUMBNAIL_IMAGE_PATH}" alt="The Generic" align="left" id="thumbnail_#{@uri}"/>)
    result = thumbnail_image_tag(item)
    assert_dom_equal(expected, result)
  end
  
  it "thumbnail_image_tag should get site image when no specific thumbnail" do
    Site.should_receive(:find_by_code).with('site').and_return(@specific_site)
    item = @item.merge({'archive' => 'site', 'title' => 'Specific Site Title'})
    expected = %(<img src="http://some.site.url.com/image.gif" alt="Specific Site Title" align="left" id="thumbnail_#{@uri}"/>)
    result = thumbnail_image_tag(item)
    assert_dom_equal(expected, result)
  end
  
  it "'thumbnail_image_tag' should get thumbnail of specific item when present" do
    Site.should_receive(:find_by_code).with('site').and_return(@specific_site)
    item = @item.merge({'archive' => 'site', 'title' => 'Specific Site Title', 'thumbnail' => 'http://some.specific.url.com/image.gif'})
    expected = %(<img src="http://some.specific.url.com/image.gif" alt="Specific Site Title" align="left" id="thumbnail_#{@uri}"/>)
    result = thumbnail_image_tag(item)
    assert_dom_equal(expected, result)
  end

  it "'thumbnail_image_tag' without extension" do
    Site.should_receive(:find_by_code).with('site').and_return(@specific_site)
    item = @item.merge({'archive' => 'site', 'title' => 'Specific Site Title', 'thumbnail' => 'http://www.purl.org/swinburnearchive/img/tsa9thmb00/'})
    expected = %(<img src="http://www.purl.org/swinburnearchive/img/tsa9thmb00/" alt="Specific Site Title" align="left" id="thumbnail_#{@uri}"/>)
    result = thumbnail_image_tag(item)
    assert_dom_equal(expected, result)
  end
  
  it "'pluralize' should work like rails version" do
    pluralize(1, "person").should == "1 person"
    pluralize(2, "person").should == "2 people"
    pluralize(2, "person", "persons").should == "2 persons"
  end
  
  it "'pluralize' should render no number" do
    pluralize(1, "person", nil, false).should == "person"
    pluralize(2, "person", nil, false).should == "people"
    pluralize(2, "person", "persons", false).should == "persons"
  end

end