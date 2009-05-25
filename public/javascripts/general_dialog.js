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

/*global Class, $, $$, $H, Element */
/*global YAHOO */

var GeneralDialog = Class.create({
	initialize: function (params) {
		this.class_type = 'GeneralDialog';	// for debugging

		// private variables
		var This = this;
		var this_id = params.this_id;
		var pages = params.pages;
		var flash_notice = params.flash_notice;
		if (flash_notice === undefined)
			flash_notice = "";
		var body_style = params.body_style;
		var row_style = params.row_style;
		var title = params.title;
		
		var flash_id = this_id + '_flash';
		var dlg_id = this_id;
		
		var selectChange = function(event, param)
		{
			var This = $(this);
			var currSelection = This.value;
			var id = param.id;
			var el = $(id);
			el.value = currSelection; 
		};

		var parent_id = 'modal_dlg_parent';
		var parent = $(parent_id);
		if (parent === null)
			parent = document.getElementsByTagName("body").item(0).appendChild(new Element('div', { id: parent_id, style: 'text-align:left;' }));
			
		this.getAllData = function() {
			var inputs = $$("#" + dlg_id + " input");
			var data = {};
			inputs.each(function(el) {
				if (el.type === 'checkbox') {
					data[el.id] = el.checked;
				} else if (el.type !== 'button') {
					data[el.id] = el.value;
				}
			});
			var textareas = $$("#" + dlg_id + " textarea");
			textareas.each(function(el) {
				var id = el.id;
				var value = el.value;
				data[id] = value;
			});
			return data;
		};
		
		this.submitForm = function(id, action) {
			var form = $(id);
			form.writeAttribute({ action: action });
			form.submit();
		};

		this.setFlash = function(msg, is_error) {
			$(flash_id).update(msg);
			if (is_error) {
				$(flash_id).addClassName('flash_notice_error');
				$(flash_id).removeClassName('flash_notice_ok');
			} else {
				$(flash_id).addClassName('flash_notice_ok');
				$(flash_id).removeClassName('flash_notice_error');
			}
		};
		
		var handleCancel = function() {
		    this.cancel();
		};
		
		var panel = new YAHOO.widget.Dialog(this_id, {
			constraintoviewport: true,
			modal: true,
			close: (title !== undefined),
			draggable: (title !== undefined),
			underlay: 'shadow',
			buttons: null
		});
		
		if (title !== undefined)
			panel.setHeader(title);

		var klEsc = new YAHOO.util.KeyListener(document, { keys:27 },  							
			{ fn:handleCancel,
				scope:panel,
				correctScope:true }, "keyup" ); // keyup is used here because Safari won't recognize the ESC keydown event, which would normally be used by default
		panel.cfg.queueProperty("keylisteners", klEsc);

		// Create all the html for the dialog
		var listenerArray = [];
		var body = new Element('div', { id: body_style });
		body.addClassName(body_style);
		var flash = new Element('div', { id: flash_id }).update(flash_notice);
		flash.addClassName("flash_notice_ok");
		body.appendChild(flash);
		
		pages.each(function(page) {
			var form = new Element('form', { id: page.page });
			form.addClassName(page.page);	// IE doesn't seem to like the 'class' attribute in the Element, so we set the classes separately.
			form.addClassName("switchable_element");
			form.addClassName("hidden");
			body.appendChild(form);
			page.rows.each(function (el){
				var row = new Element('div');
				row.addClassName(row_style);
				form.appendChild(row);
				el.each(function (subel) {
					if (subel.text !== undefined) {
						var elText = new Element('span').update(subel.text);
						elText.addClassName(subel.klass);
						if (subel.id !== undefined)
							elText.writeAttribute({ id: subel.id });
						row.appendChild(elText);
					} else if (subel.input !== undefined) {
						var el1 = new Element('input', { id: subel.input, 'type': 'text' });
						el1.addClassName(subel.klass);
						if (subel.value !== undefined)
							el1.writeAttribute({value: subel.value });
						row.appendChild(el1);
					} else if (subel.password !== undefined) {
						var el2 = new Element('input', { id: subel.password, 'type': 'password'});
						el2.addClassName(subel.klass);
						if (subel.value !== undefined)
							el2.writeAttribute({value: subel.value });
						row.appendChild(el2);
					} else if (subel.button !== undefined) {
						var input = new Element('input', { id: 'btn' + listenerArray.length, 'type': 'button', value: subel.button });
						row.appendChild(input);
						listenerArray.push({ id: 'btn' + listenerArray.length, event: 'click', callback: subel.callback, param: { curr_page: page.page, destination: subel.url, dlg: This } });
					} else if (subel.page_link !== undefined) {
						var a = new Element('a', { id: 'a' + listenerArray.length, href: '#' }).update(subel.page_link);
						a.addClassName('nav_link');
						row.appendChild(a);
						listenerArray.push({ id: 'a' + listenerArray.length, event: 'click', callback: subel.callback, param: { curr_page: page.page, destination: subel.new_page, dlg: This } });
					} else if (subel.select !== undefined) {
						var selectValue = new Element('input', { id: subel.select, name: subel.select });
						selectValue.addClassName('hidden');
						row.appendChild(selectValue);
						var select = new Element('select', { id: 'sel' + listenerArray.length });
						if (subel.klass)
							select.addClassName(subel.klass);
						row.appendChild(select);
						listenerArray.push({ id: 'sel' + listenerArray.length, event: 'change', callback: selectChange, param: { id: subel.select } });
						if (subel.options) {
							subel.options.each(function(opt) {
								select.appendChild(new Element('option', { value: opt.value}).update(opt.text));
							});
						}
					} else if (subel.custom !== undefined) {
						var custom = subel.custom;
						var div = custom.getMarkup();
						row.appendChild(div);
					} else if (subel.checkbox !== undefined) {
						var checkbox = new Element('input', { id: subel.checkbox, 'type': "checkbox", value: subel.checkbox, name: subel.checkbox });
						if (subel.klass)
							checkbox.addClassName(subel.klass);
						row.appendChild(checkbox);
					} else if (subel.textarea !== undefined) {
						var textarea = new Element('textarea', { id: subel.textarea, name: subel.textarea });
						if (subel.klass)
							textarea.addClassName(subel.klass);
						row.appendChild(textarea);
					} else if (subel.image !== undefined) {
						var image = new Element('div', { id: subel.image + '_div' });
						image.appendChild(new Element('img', { src: '', id: subel.image + "_img", alt: '' }));
						image.appendChild(new Element('input', { id: subel.image, type: 'file', name: subel.image }));
						if (subel.klass)
							image.addClassName(subel.klass);
						row.appendChild(image);
						row.appendChild(new Element('input', { id: 'authenticity_token', name: 'authenticity_token', type: 'hidden', value: form_authenticity_token }).update(form_authenticity_token));
						
						// We have to go through a bunch of hoops to get the file uploaded, since
						// you can't upload a file through Ajax.
						form.writeAttribute({ enctype: "multipart/form-data", target: "upload_target", method: 'post' });
						body.appendChild(new Element('iframe', { id: "upload_target", name: "upload_target", src: "#", style: "width:0;height:0;border:0px solid #fff;" }));

					}
				});
			});
		});

		panel.setBody(body);
		panel.render(parent_id);
		
		panel.cancelEvent.subscribe(function(e, a, o){
			setTimeout(function() { panel.destroy(); }, 500);
		});
		
		listenerArray.each(function (listen, i) {
			YAHOO.util.Event.addListener(listen.id, listen.event, listen.callback, listen.param); 
		});
		
		// These are all the elements that can be turned on and off in the dialog.
		// All elements have switchable_element, and they each then have another class
		// that matches the value of the view parameter. Then this loop either hides or shows
		// each element.
		this.changePage = function(view, focus_el) {
			var els = $$('.switchable_element');
			els.each(function (el) {
				if (el.hasClassName(view))
					el.removeClassName('hidden');
				else
					el.addClassName('hidden');
			});
			
			if (focus_el && $(focus_el))
				$(focus_el).focus();
		};
		
		this.cancel = function() {
			panel.cancel();
		};
		
		this.center = function() {
			var dlg = $(this_id);
			var w = parseInt(dlg.getStyle('width'), 10);
			var h = parseInt(dlg.getStyle('height'), 10);
			var vw = YAHOO.util.Dom.getViewportWidth();
			var vh = YAHOO.util.Dom.getViewportHeight();
			var x = (vw - w) / 2;
			var y = (vh - h) / 2;
			x += YAHOO.util.Dom.getDocumentScrollLeft();
			y += YAHOO.util.Dom.getDocumentScrollTop();
			if (x < 0) x = 0;
			if (y < 0) y = 0;
			var el = dlg.up();
			el.setStyle({ left: x + 'px', top: y + 'px'});
		};
	}
});

/////////////////////////////////////////////////////
// Here are some generic uses for the the above dialog
/////////////////////////////////////////////////////

var MessageBoxDlg = Class.create({
	initialize: function (title, message) {
		// This puts up a modal dialog that replaces the alert() call.
		this.class_type = 'MessageBoxDlg';	// for debugging

		// private variables
		var This = this;
		
		// privileged functions
		this.cancel = function(event, params)
		{
			params.dlg.cancel();
		};
		
		var dlgLayout = {
				page: 'layout',
				rows: [
					[ { text: message, klass: 'new_exhibit_label' } ],
					[ { button: 'Cancel', callback: this.cancel } ]
				]
			};
		
		var params = { this_id: "message_box_dlg", pages: [ dlgLayout ], body_style: "edit_palette_dlg", row_style: "new_exhibit_row", title: title };
		var dlg = new GeneralDialog(params);
		dlg.changePage('layout', null);
		dlg.center();
	}
});
