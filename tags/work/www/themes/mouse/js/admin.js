// загрузка ajax
function Go(s,object) 
{
	$(object).load(s, load ); 
}
// инициализация скриптов при загрузке ajax
function load() 
{
	$('#tabs').tabs(1,{fxFade: true, fxSpeed: 'fast'}); 
}
// сброс формы
function resetForm()
{
    if(window.confirm('Сбросить?')) document.form_content.reset();
}
function submitForm()
{
    if(window.confirm('Сохранить?')) document.form_content.submit();
}
// отмена формы
function Cancel(s)
{
    if(window.confirm('Отменить?')) Go(s,'#container');
}
// обработка и сохранение формы
function saveForms(form,url,parent)
{
	var prop = {};
	$(document.forms[form].elements).each( function() { if(this.checked) prop[this.name] = '1'; else prop[this.name] = escape(this.value); });
	$.post('/forms/', prop, function(data){ alert(data) })
}



// копирование 
function CopyChecked(s)
{
	$(document.form_content.elements).each( function() { 
		if(this.name.substring(0, this.name.indexOf('_'))=='check' && this.name!='check_main' && this.checked){
			Go(s+'&id='+this.name.substring(this.name.indexOf('_')+1,this.name.length),'#container');
		}
	});
}
// удаление
function DeleteChecked(s,url,parent)
{
	var del='';	
	var prop = {};
	if(window.confirm('Удалить?'))
    {
    	$(document.form_content.elements).each( function() { 
			if(this.name.substring(0, this.name.indexOf('_'))=='check' && this.name!='check_main' && this.checked){
				del = del + this.name.substring(this.name.indexOf('_')+1,this.name.length) + ',';
			} else prop[this.name] =  escape(this.value) ;
    	});
    	prop[s] = del;
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		$.post('/forms/', prop, function(data){ alert(data); $(parent).load(url);})
    }
}

function popXTextArea(name)
{
    w_location='/wymeditor/editor.html?name='+name;
    w_name='Редактирование';
    w_width=(window.innerWidth)-300;
    w_height=(window.innerHeight)-100;
    w_left=(window.innerWidth - w_width )/2;
    w_top=(window.innerHeight - w_height )/2;
    w=window.open(w_location, w_name, 'left='+w_left+', top='+w_top+', width='+w_width+', height='+w_height+', status=yes, resizable=yes, scrollbars=yes');
    w.focus();
    elems=document.getElementsByName(name);
    elems[0].disabled=true;
    elems[0].onclick='new function{w.focus()}';
}