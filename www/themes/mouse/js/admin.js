$(document)
.ready(function(){$("#container").load('/mc/admin/?type=objects')})
.ajaxStart( function () {$('#loadingAjax').show()})
.ajaxStop(  function () {$('#loadingAjax').hide()})
// �������� ajax
function Go(s,object) 
{
	$(object).load(s, load ); 
}
// ������������� �������� ��� �������� ajax
function load() 
{
	$('#tabs').tabs(1,{fxFade: true, fxSpeed: 'fast'}); 
}
// ����� �����
function resetForm()
{
    if(window.confirm('��������?')) document.form_content.reset();
}
// ������ �����
function Cancel(s)
{
    if(window.confirm('��������?')) Go(s,'#container');
}
// ��������� � ���������� �����
function saveForm(form,url,parent)
{
	var prop = {};
	$(document.forms[form].elements).each( function() { if(this.checked) prop[this.name] = '1'; else prop[this.name] = escape(this.value); });
	$.post('/ajax/go.html', prop, function(data){ alert(data); $(parent).load(url);})
}
// ����������� 
function CopyChecked(s)
{
	$(document.form_content.elements).each( function() { 
		if(this.name.substring(0, this.name.indexOf('_'))=='check' && this.name!='check_main' && this.checked){
			Go(s+'&id='+this.name.substring(this.name.indexOf('_')+1,this.name.length),'#container');
		}
	});
}
// ��������
function DeleteChecked(s,url,parent)
{
	var del='';	
	var prop = {};
	if(window.confirm('�������?'))
    {
    	$(document.form_content.elements).each( function() { 
			if(this.name.substring(0, this.name.indexOf('_'))=='check' && this.name!='check_main' && this.checked){
				del = del + this.name.substring(this.name.indexOf('_')+1,this.name.length) + ',';
			} else prop[this.name] =  escape(this.value) ;
    	});
    	prop[s] = del;
		$.post('/ajax/go.html', prop, function(data){ alert(data); $(parent).load(url);})
    }
}
// ����������� ������
function pickObject(s)
{
    w_location=s;
    w_name='picksection';
    w_width=600;
    w_height=500;
    w_left=(window.innerWidth-w_width)/2;
    w_top=(window.innerHeight-w_height)/2;
    w=window.open(w_location, w_name, 'left='+w_left+', top='+w_top+', width='+w_width+', height='+w_height+', status=yes, resizable=yes, scrollbars=yes');
    w.focus();
}
// �����
function setPick(value, title, elem)
{
    e=window.opener.document.getElementsByName(elem);
    e[0].value=value;
    e=window.opener.document.getElementsByName(elem+'_title');
    e[0].value=title;
    window.opener.focus();
    window.close();
}
function add_line(container)
{
	var contentsPlacerElem = document.getElementById(container);
	var table_container = document.createElement('div');
	var next_count = eval(parseInt(document.getElementById('add_button').getAttribute('alt')) + 1);
	table_container.setAttribute('id', 'block_to_object_' + parseInt(next_count));
	table_container.innerHTML='<input name="mode_' + next_count + '" class="input-text-short"/><input name="sort_order_' + next_count + '" class="input-text-short"/><input type="hidden" name="block_id_' + next_count + '"/><input name="block_id_' + next_count + '_title" class="input-text-medium"/><img src="/themes/mouse/icons/16_select.gif" title="�������" alt="x" class="input-image" onClick="pickObject(\'/admin/mc/picker/?type=blocks&mode=picker&elem=block_id_' + next_count + '\')" /><img src="/themes/mouse/icons/16_del_block.gif" title="������" alt="x" class="input-image" onClick="remove_line(' + next_count + ')" />';
	contentsPlacerElem.appendChild(table_container);
	document.getElementById('add_button').setAttribute('alt', next_count);
}
function remove_line(line_number){
	var line_object = document.getElementById('blocks');
	line_object.removeChild(document.getElementById('block_to_object_' + line_number));
	if(line_object.hasChildNodes() == false){document.getElementById('add_button').setAttribute('alt','0');}
}

