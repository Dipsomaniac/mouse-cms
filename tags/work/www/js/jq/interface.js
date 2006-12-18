toggleMenu = function(el)
{
	$('ul', el.parentNode).SlideToggleUp(500);
}

$(document).ready(
	function ()
	{
		if ($.browser.msie) _fixPNG();
		$('#docs').click(
			function() {
				$('ul',this.parentNode).SlideToggleUp(500);
				this.blur();
				return false;
			}
		);
		
		$('#InterfaceElements a').click(addToDownload);
		$('#saveSelection').click(buildDownload);
		$('a.goToTop').click(
			function()
			{
				$('#interface_fx').ScrollTo(1000);
				return false;
			}
		);
		$('a.toggleFxContent').click(toggleFxContent);
		a = new String(window.top.location);
		if(a.indexOf('http://interface.eyecon.ro') != 0 && a.indexOf('http://www.eyecon.ro') != 0 && a.indexOf('http://eyecon.ro') != 0)
			window.top.location.href = 'http://interface.eyecon.ro';
	}
);

toggleFxContent = function()
{
	$(this.parentNode.nextSibling).toggle();
	$(this).ScrollTo(500);
	this.blur();
	return false;
}


buildDownload = function()
{
	$(this).hide();
	$('#saveAjax').show();
	selected = [];
	for (i in selectedElements) {
		if (selectedElements[i] == true) {
			selected[selected.length] = i;
		}
	}
	if (selected.length == 0) {
		$(this).show();
		$('#saveAjax').hide();
		alert('You must select at least one element.');
		return false;
	}
	
	building = true;
	
	data = {
		request: 'buildDownload',
		selection: selected
	};
	
	$.ajax(
		{
			url: '/ajax/server.php',
			data: $.param(data),
			type: 'POST',
			complete: function(intoarce)
			{
				xml = $.httpData(intoarce);
				okies = $('ok', xml);
				errors = $('error', xml);
				if (errors.size() > 0) {
					errors.each(
						function()
						{
							alert($(this).text());
						}
					);
					return;
				}
				$('#toDownload').val(pack(okies.text(),62, true));
				$('#downloadForm').get(0).submit();
			},
			success: function()
			{
				$('#saveSelection').show();
				$('#saveAjax').hide();
				building = false;
			},
			error: function()
			{
				$('#saveSelection').show();
				$('#saveAjax').hide();
				building = false;
			}
		}
	);
	/*for(i = 0; i < selected.length; i++)
	{
		inputEl = document.createElement('input');
		$(inputEl).attr(
			{
				type	: 'hidden',
				name	: 'selected[]',
				value	: selected[i]
			}
		);
		$('#downloadForm').append(inputEl);
	}
	$('#downloadForm').get(0).submit();*/
	
	return false;
}
var building = false;
var selectedElements = {};

addToDownload = function()
{
	if (building == true)
		return false;
	this.blur();
	el = $(this);
	id = el.attr('id');
	if (!selectedElements[id]) {
		selectedElements[id] = true;
		target = $('#yourSelection div');
		if ((id == 'idrop' || id == 'isort' || id == 'islider') && !selectedElements.idrag) {
			target.append('<a href="#" id="d_idrag" rel="idrag"><img src="/site/delete.png" />Draggables</a>');
			$('#idrag').Puff(400);
			$('#d_idrag').click(deleteFromDownload).Pulsate(100,2);
			selectedElements.idrag = true;
		}
		
		if (el.attr('id') == 'isort' && !selectedElements.idrop) {
			target.append('<a href="#" id="d_idrop" rel="idrop"><img src="/site/delete.png" />Droppables</a>');
			$('#idrop').Puff(500);
			$('#d_idrop').click(deleteFromDownload).Pulsate(100,2);
			selectedElements.idrop = true;
		}
		
		target.append('<a href="#" id="d_' + el.attr('id') + '" rel="' + el.attr('id') + '"><img src="/site/delete.png" />' + el.text() + '</a>');
		el.TransferTo(
			{
				to: 'd_' + el.attr('id'),
				duration: 500,
				className: 'transfer',
				complete: function(to)
				{
					$(to).click(deleteFromDownload).Pulsate(100,2);
				}
			}
		).Puff(400);/*.Puff(500);*/
	}
	return false;
}

deleteFromDownload = function ()
{
	if (building == true)
		return false;
	this.blur();
	el = $(this);
	target = el.attr('rel');
	if (target == 'idrop' || target == 'idrag') {
		if(selectedElements.isort) {
			$('#isort').show().fadeIn(500);
			$('#d_isort').DropOutDown(400, function(){$(this).remove()});
			selectedElements.isort = null;
		}
	}
	if (target == 'idrag') {
		if(selectedElements.idrop) {
			$('#idrop').show().fadeIn(500);
			$('#d_idrop').DropOutDown(400, function(){$(this).remove()});
			selectedElements.idrop = null;
		}
		if(selectedElements.islider) {
			$('#islider').show().fadeIn(500);
			$('#d_islider').DropOutDown(400, function(){$(this).remove()});
			selectedElements.islider = null;
		}
	}
	$('#' + target).show().fadeIn(500);
	$(this).DropOutDown(400, function(){$(this).remove()});
	selectedElements[target] = null;
	return false;
}

function _fixPNG() {
	var images = $('img[@src*="png"]'), png;
	images.each(
		function() {
			png = this.src;
			this.src = '/site/spacer.gif';
			this.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(src='" + png + "')";
		}
	);
}