jQuery(document).ready(function($) {
	"use strict";

	function searchFormType(key) {
		var types = {
			a: 'Archive',
			discipline: 'Discipline',
			g: 'Genre',
			q: 'Search Term',
			doc_type: 'Format',
			t: "Title",
			aut: "Author",
			ed: 'Editor',
			pub: "Publisher",
			art: 'Artist',
			own: 'Owner',
			y: 'Year',
			lang: 'Language'
		};
		if (types[key])
			return types[key];
		return key;
	}

	function searchNot() {
		return '<select class="query_and-not_select"><option>AND</option><option>NOT</option></select>';
	}

	function searchRemove(key, value) {
		return window.pss.createHtmlTag("button", {'class': "trash select-facet", 'data-key': key, 'data-value': value, 'data-action': 'remove' }, '<img alt="Remove Term" src="/assets/lvl2_trash.gif">' );

	}

	function newSearchTerm() {
		var searchTypes = [ ['Search Term', 'q'], ['Title', 't'] ];
		if (window.collex.hasFuzzySearch) {
			searchTypes.push(['Language', 'lang']);
			searchTypes.push(['Year (YYYY)', 'y']);
			// TODO-PER: get the roles that are in the facets.
		} else {
			searchTypes.push(['Author', 'aut']);
			searchTypes.push(['Editor', 'ed']);
			searchTypes.push(['Publisher', 'pub']);
			searchTypes.push(['Artist', 'art']);
			searchTypes.push(['Owner', 'own']);
			searchTypes.push(['Year (YYYY)', 'y']);
		}
		var selectTypeOptions = "";
		for (var i = 0; i < searchTypes.length; i++)
			selectTypeOptions += window.pss.createHtmlTag("option", {value: searchTypes[i][1] }, searchTypes[i][0]);
		var selectType = window.pss.createHtmlTag("select", {'class': "query_type_select" }, selectTypeOptions); // TODO-PER: onchange='searchTypeChanged(this);'
		var searchBox = window.pss.createHtmlTag("input", { type: 'text', placeholder: "click here to add new search term", autocomplete: 'off' }) +
			window.pss.createHtmlTag("div", {'class': "auto_complete", id: "search_phrase_auto_complete", style: "display: none;" }, '');
		var submitButton = window.pss.createHtmlTag("button", { 'class': "query_add" }, 'Add');
		return window.pss.createHtmlTag("tr", { },
			window.pss.createHtmlTag("td", {'class': "query_type" }, selectType) +
			window.pss.createHtmlTag("td", {'class': "query_term" }, searchBox) +
			window.pss.createHtmlTag("td", {'class': "query_and-not" }, searchNot()) +
			window.pss.createHtmlTag("td", { 'class': "query_remove" }, submitButton) );
	}

	window.collex.createSearchForm = function(query) {
		var table = $('.search-form');
		var html = "";
		for (var key in query) {
			if (query.hasOwnProperty(key) && key !== 'page' && key !== 'srt' && key !== 'dir' && key !== 'f') {
				var values = (typeof query[key] === 'string') ? [ query[key] ] : query[key];
				for (var i = 0; i < values.length; i++) {
					var value = values[i];
					var displayedKey = key;
					if (key === 'a') {
						var a = window.collex.getArchive(value);
						if (a) value = a.name;
					} else if (key === 'o') {
						switch (value) {
							case 'typewright': displayedKey = 'TypeWright'; value = 'Only resources that can be edited.'; break;
							case 'freeculture': displayedKey = 'Free Culture'; value = 'Only resources that are freely available in their full form.'; break;
							case 'fulltext': displayedKey = 'Full Text'; value = 'Only resources that contain full text.'; break;
						}
					}
					html += window.pss.createHtmlTag("tr", {},
						window.pss.createHtmlTag("td", {'class': "query_type"}, searchFormType(displayedKey)) +
						window.pss.createHtmlTag("td", {'class': "query_term"}, value) +
						window.pss.createHtmlTag("td", {'class': "query_and-not"}, searchNot()) +
						window.pss.createHtmlTag("td", {'class': "query_remove"}, searchRemove(key, values[i])));
				}
			}
		}
		html += newSearchTerm();
		return table.html(html);
	};

});