var first_event = null, second_event = null;
function checkAll()
{
    if(chb=document.getElementsByName('check_main'))
    {
        if(chb[0].checked) check=true;
        else check=false;
        num=document.form_content.length;
        for(var i=0; i<num; i++)
        {
            e=document.form_content[i];
            if(e.name.substring(0, e.name.indexOf('_'))=='check' && e.name!='check_main')
                e.checked=check;
        }
    }
}

function markAll()
{
    if(chb=document.getElementsByName('check_main'))
    {
        num=document.form_content.length;
        for(var i=0; i<num; i++)
        {
            e=document.form_content[i];
            if(e.name.substring(0, e.name.indexOf('_'))=='check' && e.name!='check_main')
            {
                id=e.name.substring(e.name.lastIndexOf('_')+1, e.name.length);
                if(tr=document.getElementById('tr_'+id))
                    if(e.checked) tr.className='highlight';
                    else tr.className='';
            }
        }
    }
}

function markRow(id)
{
    if(e=document.getElementById('tr_'+id))
        if(chb=document.getElementsByName('check_'+id))
            if(chb[0].checked) e.className='highlight';
            else e.className='';
}

function checkBox(id)
{
    if(chb=document.getElementsByName('check_'+id))
        if(chb[0].checked) chb[0].checked=false;
        else chb[0].checked=true;
}
function doMark(id)
{
    if (!first_event) {
        first_event = setTimeout(function() {checkBox(id);markRow(id);}, 100);
    } else {
        second_event = setTimeout(function() {checkBox(id);markRow(id);}, 100);
    }
}

function setFilter(field, value)
{
    e=document.getElementsByName('sys_ffield');
    e[0].value=field;
    e=document.getElementsByName('sys_fvalue');
    e[0].value=value;
    e=document.getElementsByName('fquery');
    e[0].value=field+' = '+value;
}

function clearFilter()
{
    e=document.getElementsByName('sys_ffield');
    e[0].value='';
    e=document.getElementsByName('sys_fvalue');
    e[0].value='';
    e=document.getElementsByName('fquery');
    e[0].value='';
}

function ShowLocate(id, ev)
{
    if(e=document.getElementById(id))
    {
        if (e.style.visibility != 'visible') {
            e.style.visibility = 'visible';
        }
        if (e.style.display != 'block') {
            e.style.display = 'block';
        }
    	var pos = getCursorPosition(ev);
    	var posX = pos.x;
    	var posY = pos.y

        if (posX + e.offsetWidth >= window.screen.width) {
            e.style.left = (posX - e.offsetWidth) + 'px';
        } else {
            e.style.left = posX + 'px';
        }

        if (posY >= window.screen.height) {
            e.style.top = (posY - e.offsetHeight) + 'px';
        } else {
            e.style.top = posY + 'px';
        }
    }
}

function Hide(id)
{
    if(e=document.getElementById(id))
        e.style.visibility='hidden';
}

function getCursorPosition(e)
{
	var x = 0, y = 0;
	
	if (!e) {
	    e = window.event;
	}
	
	if (e.pageX || e.pageY)	{
		x = e.pageX;
		y = e.pageY;
	} else if (e.clientX || e.clientY) {
		x = e.clientX + getBodyScrollLeft();
		y = e.clientY + getBodyScrollTop();
	}
	
    return {x: x, y: y};
}

function doEdit(s,obj)
{
    clearTimeout(first_event);
    first_event = false;
    clearTimeout(second_event);
    second_event = false;
    Go(s,obj);
}

