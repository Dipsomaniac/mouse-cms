/* 	
	Copyright (c) Art. Lebedev Studio | http://www.artlebedev.ru/

	Author - Andrew Shitov (ash@design.ru) | 2005-2006

	Original drag mechanics was written by Mike Hall (http://www.brainjar.com/dhtml/drag/) in 2001.
*/

var isMSIE = document.attachEvent != null;
var isGecko = !document.attachEvent && document.addEventListener;
var idObject = '';
var coordObject = '';
var DraggingItem = new Object();

function StartDrag (event, _this, _afteraction)
{
	DraggingItem.This = _this;
	DraggingItem.AfterAction = _afteraction;

	var position = new Object();
	if (isMSIE)
	{
		position.x = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;
		position.y = window.event.clientY + document.documentElement.scrollTop + document.body.scrollTop;
	}
	if (isGecko)
	{
		position.x = event.clientX + window.scrollX;
		position.y = event.clientY + window.scrollY;
	}

	DraggingItem.cursorStartX = position.x;
	DraggingItem.cursorStartY = position.y;

	DraggingItem.StartLeft = parseInt (DraggingItem.This.style.left);
	DraggingItem.StartTop = parseInt (DraggingItem.This.style.top);

	if (isNaN (DraggingItem.StartLeft)) DraggingItem.StartLeft = 0;
	if (isNaN (DraggingItem.StartTop)) DraggingItem.StartTop = 0;

	if (isMSIE)
	{
		document.attachEvent ("onmousemove", ProceedDrag);
		document.attachEvent ("onmouseup", StopDrag);
		window.event.cancelBubble = true;
		window.event.returnValue = false;
	}
	if (isGecko)
	{
		document.addEventListener ("mousemove", ProceedDrag, true);
		document.addEventListener ("mouseup", StopDrag, true);
		event.preventDefault();
	}
}

function ProceedDrag (event)
{
	var position = new Object();

	if (isMSIE) {
		position.x = window.event.clientX + document.documentElement.scrollLeft + document.body.scrollLeft;
		position.y = window.event.clientY + document.documentElement.scrollTop + document.body.scrollTop;
	}
	if (isGecko)
	{
		position.x = event.clientX + window.scrollX;
		position.y = event.clientY + window.scrollY;
	}	

	var nextX = DraggingItem.StartLeft + position.x - DraggingItem.cursorStartX;
	if (nextX < 0) nextX = 0;
	DraggingItem.This.style.left = nextX + "px";

	var nextY = DraggingItem.StartTop  + position.y - DraggingItem.cursorStartY;
	if (nextY > 560) nextY = 560;
	DraggingItem.This.style.top = nextY + "px";

	if (isMSIE)
	{
		window.event.cancelBubble = true;
		window.event.returnValue = false;
	}
	if (isGecko) event.preventDefault();
}

function StopDrag (event)
{	
	if (isMSIE)
	{
		document.detachEvent ("onmousemove", ProceedDrag);
		document.detachEvent ("onmouseup", StopDrag);
	}
	if (isGecko)
	{
		document.removeEventListener ("mousemove", ProceedDrag, true);
		document.removeEventListener ("mouseup", StopDrag, true);
	}

	if (DraggingItem.AfterAction) DraggingItem.AfterAction (DraggingItem.This);

	SaveDesktop();
}

function SaveDesktop()
{
	var draggables = document.getElementsByTagName ('div');
	var desktopLayout = '';
	
	for (var c = 0; c != draggables.length; c++)
	{
		var current = draggables[c];
		if (current.className == 'draggable')
		{
			desktopLayout += current.id + '(' + parseInt (current.style.left) + ',' + parseInt (current.style.top) + ');';
			
		}
	}
	
	var expires = new Date();
	expires = new Date (expires.getYear() + 1901, expires.getMonth(), 1);
	
	setCookie ('layoutN', desktopLayout, expires, '/');
	CountItems();
}

function CountItems()
{
	var draggables = document.getElementsByTagName ('div');
	var desktopLayout = '';
    idObject = '';
    coordObject = '';
	
	var count = 0;
	for (var c = 0; c != draggables.length; c++)
	{
		var current = draggables[c];
		if (current.className == 'draggable')
		{
			var left = parseInt (current.style.left);
			var top = parseInt (current.style.top);
			if (left > -20 && left < 180 && top > -20 && top < 590) 
			{
				count++;
				idObject +=current.id + ',';
				coordObject +=left+'|'+top+',';
			}
	if (left > 230 && left < 310 && top > 20  && top < 130) formOpen('edit/?now='  +current.id);
	if (left > 230 && left < 310 && top > 140 && top < 250) formOpen('del/?now='   +current.id);
	if (left > 230 && left < 310 && top > 260 && top < 370) formOpen('data/?now='  +current.id,'','850','550');
	if(window.request == '/admin/block/'){
		str=' блок';
		if (left > 230 && left < 310 && top > 380 && top < 490) m_ajaxDo('/admin/block/process/?now='+current.id,'AjaxLayer');
	}
	else
	{str=' обработчик'}
		}
	}
	
	var ItemsCounter = document.getElementById ('ItemsCounter');
	if (ItemsCounter)
	{
		var flexia = '';
		switch (count)
		{
			case 1: 
				break;
			case 2: 
			case 3: 
			case 4: 
				flexia = 'а'; break;
			default:
				flexia = 'ов'; break;	
		}
		ItemsCounter.innerHTML = count ? count + str + flexia : ' нету блоков';
	}
}

function PutBack (item)
{
	item.style.zIndex = 2;;
}

function setCookie (name, value, expire, path)
{
	document.cookie = name + '=' + escape (value)
		+ ((expire == null)? '' : ('; expires=' + expire.toGMTString()))
		+ ((path == null)? '' : ('; path=' + path));
}
function saveIdObject(id)
{
	saveMyObject(id,idObject,coordObject);
}
