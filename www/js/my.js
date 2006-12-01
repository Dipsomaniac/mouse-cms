/** Init **/
var ajaxObjects = new Array();
var m_lastMemory = '';
/** Show **/
function m_ajaxShow(name,str)
{
	var e = document.getElementById(name);
	ajax_parseJs(e);
	if(str) e.innerHTML = str;
	initFormValidation();
}

/** States **/
function m_ajaxLoading(name)     { m_ajaxShow(name,'<h2>Посылаю запрос...</h2>');   }
function m_ajaxLoaded(name)      { m_ajaxShow(name,'<h2>Запрос отправлен...</h2>'); }
function m_ajaxInteractive(name) { m_ajaxShow(name,'<h2>Получаю данные...</h2>');   }
function m_ajaxComplete(index)   { alert(ajaxObjects[index].response);              }

/** DoIT **/
function m_ajaxDo(ContentUrl,name,Complete){
	var ajaxIndex                        = ajaxObjects.length;
	ajaxObjects[ajaxIndex]               = new sack();
	ajaxObjects[ajaxIndex].requestFile   = ContentUrl;
	if (Complete) 
	{ 
		ajaxObjects[ajaxIndex].onCompletion = function(){ m_ajaxComplete(ajaxIndex); }; 
	}
	else 
	{
		ajaxObjects[ajaxIndex].element       = name;
		ajaxObjects[ajaxIndex].onLoading     = function(){ m_ajaxLoading(name); };
		ajaxObjects[ajaxIndex].onLoaded      = function(){ m_ajaxLoaded(name); };
		ajaxObjects[ajaxIndex].onInteractive = function(){ m_ajaxInteractive(name); };
		ajaxObjects[ajaxIndex].onCompletion  = function(){ m_ajaxShow(name); };
	}
	ajaxObjects[ajaxIndex].runAJAX();
}

/** FormDoIT **/
function m_ajaxFormDo(ContentUrl,form){
	var ajaxIndex                        = ajaxObjects.length;
	ajaxObjects[ajaxIndex]               = new sack();
	ajaxObjects[ajaxIndex].requestFile   = ContentUrl;
	if (form) {
	for(var i = 0;i < document.forms[form].elements.length;i++) {
		if(document.forms[form].elements[i].checked) {	ajaxObjects[ajaxIndex].setVar(document.forms[form].elements[i].name, '1') }
		else if(document.forms[form].elements[i].value) { 
			 ajaxObjects[ajaxIndex].setVar(document.forms[form].elements[i].name,document.forms[form].elements[i].value); }}
	}
	ajaxObjects[ajaxIndex].onCompletion =  function(){ m_ajaxComplete(ajaxIndex); };
	ajaxObjects[ajaxIndex].runAJAX();
}

/** ParseJs **/
function ajax_parseJs(inputObj)
{	
	var jsTags = inputObj.getElementsByTagName('SCRIPT');
	for(var no=0;no<jsTags.length;no++){
		eval(jsTags[no].innerHTML);
	}	
}

/** MyFunction **/
function formOpen(url,parent,x,y){
	m_lastMemory =(window.request||parent);
	displayMessage(window.request+url,x,y); }
function saveMyObject(id,bid,coord){
	Complete = true;
	m_ajaxDo('/ajax/saveMyObject.html?id=' + id + '&bid=' + bid + '&coord=' + coord,'AjaxLayer',Complete); }
function saveMyForm(ContentUrl,form){
	if(!isFormValid()) { alert('Правильно заполните выделенные поля'); return false; }
	m_ajaxFormDo(ContentUrl,form);
//	closeMessage();
	m_ajaxDo(m_lastMemory,'AjaxLayer'); }
function m_ajaxBlockDel(ContentUrl){
	m_ajaxFormDo(ContentUrl);
	closeMessage();
	m_ajaxDo(m_lastMemory,'AjaxLayer'); }
function saveMyTree(){
	Complete = true;
	m_ajaxDo('/ajax/saveTreeObject.html?saveString=' + treeObj.getNodeOrders(),'AjaxLayer',Complete); }
/** MyFunction **/
