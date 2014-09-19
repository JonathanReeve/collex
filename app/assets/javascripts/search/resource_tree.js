//------------------------------------------------------------------------
//    Copyright 2009 Applied Research in Patacriticism and the University of Virginia
//
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//----------------------------------------------------------------------------

/*global serverNotify */

jQuery(document).ready(function($) {
	"use strict";
	var body = $("body");

	body.on("click", ".resource-tree-node button", function () {
		var el = $(this);
		var parent = el.closest(".resource-tree-node");
		var open = parent.find('button[data-action="open"]');
		var action = el.attr('data-action');
		var id = parent.attr('data-id');
		if (action === 'toggle') {
			action = open.is(':visible') ? 'open' : 'close';
		}

		var archive = window.collex.getArchiveNode(id);
		if (archive)
			archive.toggle = action;

		// Now close the items that need to be closed -- we'll just redraw using the same function that hid the nodes originally.
		var block = $(".facet-archive");
		block.find("tr").show();
		block.find("button").show();
		window.collex.setResourceToggle(block, window.collex.facetNames.archives);

		serverNotify("/search/remember_resource_toggle", { dir: action, id: id });

	});
});
