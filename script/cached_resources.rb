#!/usr/bin/env ruby
##########################################################################
# Copyright 2008 Applied Research in Patacriticism and the University of Virginia
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

require 'optparse'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

def parse_command_line( command_line_args )
  status = true
  action = nil
  
  @opts = OptionParser.new do |opts|  
        
    opts.on("-f", "--fill", "Fill the resource cache based on existing interpretations table.") do |d|
      action = :fill
    end

    opts.on("-c", "--clear", "Clear the resource cache.") do |d|
      action = :clear
    end
    opts.on("-r", "--refill", "Clear, then fill the resource cache.") do |d|
      action = :refill
    end

    ## Display help message 
    opts.on_tail("-h","--help", "Show this usage statement.") do |h|
      puts opts
      status = false
    end
  end

  begin
    @opts.parse!(command_line_args)
  rescue Exception => e
    puts e, "", @opts
    status = false
  end
  
  (status) ? action : nil 
end

def clear_resource_cache()
  puts "Clearing the resource cache..."  
#   CachedResource.destroy_all
  # Calling SQL directly is faster
  CachedResource.connection.execute("delete from cached_properties")
  CachedResource.connection.execute("delete from cached_resources")
  CachedResource.connection.execute("delete from cached_resources_tags")
end

# Update the document cache based on the existing interpretations.
def fill_resource_cache()
  puts "Filling cached_resources..."
  interpretations = Interpretation.find(:all)     
  interpretations.each do |interpretation|
    puts "For URI: #{interpretation.object_uri}"
    cached_resource = CachedResource.resources_by_uri(interpretation.object_uri)
    unless cached_resource.nil? 
      interpretation.tags.each { |tag| cached_resource.tags << tag }
      cached_resource.save!
    end
  end
end

# Run
case parse_command_line(ARGV)
  when :clear 
    clear_resource_cache
  when :fill 
    fill_resource_cache
  when :refill 
    clear_resource_cache
    fill_resource_cache
  else
    puts @opts
end
