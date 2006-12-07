@CLASS
engine

#################################################################################################
#                                                                                               #
#      ИНИЦИАЛИЗАЦИЯ   САЙТЫ   ОБРАБОТЧИКИ   ШАБЛОНЫ   СИСТЕМНЫЕ КОНСТАНТЫ                      #
#                                                                                               #
#################################################################################################
# Конструктор инициализация и выполнение engine
@init[][siteID;suteLangID]
# получаем ВСЕ сайты
$SITES[^getSITES[]]
$SITES_HASH[^SITES.hash[id]]
# получение ID сайта и ID языка сайта =debug а если такого сайта нету?
^if(^SITES.locate[domain;$env:SERVER_NAME]){$siteID($SITES.id) $siteLangID($SITES.lang_id)}
$SYSTEM[
	$.SiteUrl[$env:SERVER_NAME]
#	полный путь запрошенного объекта (/admin/index.html)
	$.fullPath[$request:uri]
#	путь объекта
#	$.path[$env:PATH_INFO]
	$.path[$MAIN:sPath]
	$.siteID(^siteID.int(0))
	$.siteLangID(^siteLangID.int(0)) #=debug
]
# получаем ВСЕ ОПУБЛИКОВАННЫЕ объекты текущего сайта
$OBJECTS[^getOBJECTS[$.where[m_object.site_id ='$SYSTEM.siteID' AND m_object.is_published ='1']]]
$OBJECTS_HASH[^OBJECTS.hash[id]]
# обработчики и шаблоны получаем в любом случае
# таблица обработчиков
$PROCESSES[^getPROCESSES[]]
$PROCESSES_HASH[^PROCESSES.hash[id]]
# таблица шаблонов
$TEMPLATES[^getTEMPLATES[]]
$TEMPLATES_HASH[^TEMPLATES.hash[id]]
# хэш основных параметров сайта
#end @init[]

#################################################################################################
#                                                                                               #
#      ОШИБКИ   ВЫПОЛНЕНИЕ                                                                      #
#                                                                                               #
#################################################################################################
# "Чух, чух, чух" - Поехали!
@execute[][str]
^try{
#	построение объекта
	$result[^create[]]
}{
	$str[$exception.type]
	^if(^str.pos[cms] == 0){
# 		обработка исскуственно сгенерированных ошибок смс
		$exception.handled(1)
# 		и отправляем по адресу
		$result[
  			^if(^OBJECTS.locate[id;$SITES_HASH.[$SYSTEM.siteID].e404_object_id]){
    				^location[$OBJECTS.full_path?error=$exception.type&url=$SYSTEM.path;$.is_external(1)]
			}{
				^throw[$exception.type;$env:SERVER_NAME;Страница ошибок не найдена ($exception.comment)]
			}
		]
#		$result[произошла ошибка "$exception.type" - $exception.comment]
	}
}
# end @execute[][str]

#################################################################################################
#                                                                                               #
# ОБЪЕКТЫ   ПРАВА   ТИП ВЫВОДА   ОЧИСТКА ПАМЯТИ   РАБОТА С ШАБЛОНОМ                             #
#                                                                                               #
#################################################################################################
# создание страницы сайта
@create[][ACL]
# если зажжен флажок отсутствия кэш файла - создаем его
^if($MAIN:bCacheFile){^createCacheFile[]}
# проверка существования запрошенного объекта, существует - создаем, иначе отправка на страницу ошибок
^OBJECTS.menu{^if($OBJECTS.full_path eq $SYSTEM.path){$OBJECT[$OBJECTS.fields]}}
^if(!def $OBJECT){^throw[cms.404;$request:uri;Страница не найдена]}
^if(def $OBJECT.url){
#	если определено поле $OBJECT.url - location по адресу 
	$result[^location[^taint[as-is][$OBJECT.url]]]
}{
# 	ветвь текущего объекта
	$OBJECT_THREAD[^OBJECTS.select($OBJECTS.thread_id == $OBJECT.thread_id)]
#	хэш объектов по parent_id (для наследования навигации)
	$OBJECTS_HASH_TREE[^OBJECTS.hash[parent_id][$.distinct[tables]]]
#	=debug тут реализовать проверку прав на объект 
	$RIGHTS($OBJECT.rights)
	^if($MAIN:objAuth.is_logon){
#		достаем назначения прав текущему пользователю на все объекты треда
		$ACL[^MAIN:objAuth.getFullACL[$OBJECT_THREAD]]
#		определяем права авторизированного пользователя на объект
		$RIGHTS(^MAIN:objAuth.getRightsToObject[$OBJECT;$OBJECT_THREAD;$ACL;^if($MAIN:objAuth.user.id == $OBJECT.auser_id){1}{0}])
	}
	$HASH_RIGHTS[^getHashRights[$RIGHTS]]
#	определение необходимого content и выдача его содержимого
	^if($HASH_RIGHTS.read){
		$result[^contentSwitcher[]]
	}{
		^throw[cms.403;$uri;доступ к объекту запрещен]
	}
}
# end @create[][str]

#################################################################################################
# создание файла кэша
@createCacheFile[][_tCache]
$_tCache[^table::create{id	full_path	cache_time
^OBJECTS.menu{$OBJECTS.id	$OBJECTS.full_path	$OBJECTS.cache_time
}}]
^_tCache.save[${MAIN:CacheDir}_cache.cfg]
#end @createCacheFile[]

#################################################################################################
# развилка-переключатель xml <=> html
@contentSwitcher[][_xDoc;_sStylesheet]
# формируем xml тело
$_xDoc[^getDocumentXML[]]
$_sStylesheet[^getStylesheet[]]
# проверка строки запроса
^if(!$MAIN:EngineXML){
#	получение XSLT шаблона =debug вывод на печать реализовать как то по другому чтоли
	^if($form:mode eq print){$_sStylesheet[${MAIN:TemplateDir}print.xsl]}
#	Очистка памяти
	^clearMemory[]
#	XSLT трансформация
	$_xDoc[^_xDoc.transform[$_sStylesheet]]
}
$result[^_xDoc.string[]]

# =debug чистка лишних переносов строк - задолбали
# =debug а оно надо вообще таким способом и в этом месте?
$result[^result.match[( +)][g]{ }]
$result[^result.match[(\n\s*\n)][g]{}]

# end @contentSwitcher[][doc;stylesheet]

#################################################################################################
# очистка памяти перед результирующей трансформацией =work
@clearMemory[]
# системные переменные
$SYSTEM[]
$SITES[]
$SITES_HASH
$OBJECT[]
$OBJECTS_HASH[]
$OBJECTS[]
$OBJECT_THREAD[]
$OBJECTS_HASH_TREE[]
$TYPES[]
$TYPES_HASH[]
$TEMPLATES[]
$TEMPLATES_HASH[]
$PROCESSES[]
$PROCESSES_HASH[]
$ACL[]
$BLOCKS[]
$BLOCKS_HASH[]
$TYPES[]
$TYPES_HASH[]
$USERS[]
$USERS_HASH[]
# очистка памяти
^memory:compact[]
#end @clearMemory[]

#################################################################################################
#создание XSLT обработчика
@getStylesheet[][_sFileName]
# имя файла шаблона
$_sFileName[${MAIN:TemplateDir}$TEMPLATES_HASH.[$OBJECT.template_id].filename]
^if(-f $_sFileName){
#	result - полное путь + имя шаблона
	$result[$_sFileName]
}{
#	ошибка, для шаблона не задан XSLT шаблон
	^throw[cms.500;$_sFileName;Для объекта не задан XSLT шаблон]
}
#end @getStylesheet[]

#################################################################################################
# создание документа на основе собранного xml
# да и тут собссно тоже
@getDocumentXML[]
$result[^xdoc::create{<?xml version="1.0" encoding="$request:charset"?>
<!DOCTYPE site_page [
	^entitySet[]
]>
<document xmlns:system="http://klen.zoxt.net/doc/" lang="$SYSTEM.siteLangID" server="$env:SERVER_NAME" template="^getStylesheet[]">
  ^getDocumentBody[]
</document>
}]
# end @documentXML[]

#################################################################################################
# сборка xml документа
# в случае, если определен обработчик - упрвление полностью передается ему -
# возможость перекрыть поля и методы, вызываемые при @default_body[]
# в противном случае - сбор default блоков, заголовков и параметров
@getDocumentBody[]
^if(^OBJECT.data_process_id.int(0)){
#	передача управления обработчику объекта 
	$result[^executeProcess[$OBJECT.data_process_id]]
}{
#	default сборка
	$result[^getDocumentBodyDefault[]]
}
#end @documentBody[]

#################################################################################################
# default сборка тела xml документа
@getDocumentBodyDefault[]
$result[
<system>
	<!-- ID и URL сайта -->
	<site id="$SYSTEM.siteID">$SYSTEM.SiteUrl</site>
	<!-- запрошеннный URI -->
	<request-uri>$env:REQUEST_URI</request-uri>
	<!-- URI объекта  -->
	<request-path>$SYSTEM.fullPath</request-path>
	<!-- QUERY объекта  -->
	<request-query>$request:query</request-query>
	<!-- дата и время  -->
	<datetime>^MAIN:dtNow.sql-string[]</datetime>
</system>
<header>
	<!-- ID объекта -->
	<object-id>$OBJECT.id</object-id>
	<!-- ID родителя -->
	<parent-id>$OBJECT.parent_id</parent-id>
	<!-- Имя XSLT шаблона -->
	<template>^getStylesheet[]</template>
	<!-- ID обработчика -->
	<data_process-id>$OBJECT.data_process_id</data_process-id>
	<!-- ID типа объекта -->
	<object_type-id>$OBJECT.object_type_id</object_type-id>
	<!-- ссылка на объект (ID) --> 
# 	=debug нет работы с типом ссылки (link_to_object_id_type)
	<link_to_object-id>$OBJECT.link_to_object_id</link_to_object-id>
	<!-- имя объекта -->
	<name>$OBJECT.name</name>
	<!-- title страницы -->
	<window_name>^if(def $OBJECT.window_name){$OBJECT.window_name}{$OBJECT.name}</window_name>
	<!-- заголовок страницы -->
	<document_name>^if(def $OBJECT.document_name){$OBJECT.document_name}{$OBJECT.name}</document_name>
	<!-- реальный объекта на сайте -->
	<full_path>$OBJECT.full_path</full_path>
# 	=debug работа с кэшем не реализована
	<cache-time>$OBJECT.cache_time</cache-time>
	<!-- основной файл стиля CSS -->
	<css source="$TEMPLATES_HASH.[$OBJECT.template_id].params" />
#	<!-- keywords --> =debug
#	<keywords>^kewords[]</keywors>
</header>
<navigation>
#	создаем дерево навигации
	^ObjectByParent[$OBJECTS_HASH_TREE;0;$.description[1]]
</navigation>
<body>
#	сборка блоков
	^getBlocks[]
</body>
]
#end @documentBodyDefault[]


##################################################################################################
##                                                                                              ##
## БЛОКИ   ОБРАБОТЧИКИ   ПРЕОБРАЗОВАНИЯ                                                         ##
##                                                                                              ##
##################################################################################################
# обработка блоков объекта
@getBlocks[][BLOCKS]
# опубликованнные блоки текущего объекта и (=debug не работает подчиненных) подчиненных объектов предназначенные для автоматической обработки
$BLOCKS_NOW[^getBLOCK_TO_OBJECT[$.where[
	object_id IN ( 
#		если тип объекта не "уникальный"
		^if($OBJECT.object_type_id != 3){
#			приходят блоки всех глобальных объектов
			^OBJECTS.menu{^if(^OBJECTS.object_type_id.int(0) == 2){$OBJECTS.id ,}}
		}
#		eсли определено поле link_to_object_id объект получит информацию другого объекта
		^if(^OBJECT.link_to_object_id.int(0)){	$OBJECT.link_to_object_id }{ $OBJECT.id }
	)
	AND m_block.is_published = 1 AND m_block.is_parsed_manual != 1]]]
# сортировка блоков по y
$result[^BLOCKS_NOW.menu{^getBlock[$BLOCKS_NOW.fields]}]
#end @parseDefaultBlocks[]

#################################################################################################
# Собираем блок
@getBlock[blockFields][_cBlock;blockParams;blockData]
$result[
	$blockParams[^getSystemParams[$blockFields.attr]]
	$_cBlock{
#	 	если блок не пустой парсим его данные =debug эта штука поважнее должна быть
		^if(^blockFields.is_not_empty.int(0)){$blockData[^taint[as-is][$blockFields.data]]}
#	 	передача управления обработчику блока (если есть)
		^if(^blockFields.data_process_id.int(0)){$blockData[^executeBlock[$blockFields.data_process_id;$blockParams;$blockData;$blockFields]]}
#	 	замена спец конструкций в теле блока
		$blockData[^parseBlockPostProcess[$blockParams;$blockData]]
#	 	и собираем фрагмент блока
<block 
			id="$blockFields.id" 
			name="$blockFields.name" 
			mode="$blockFields.mode" 
			style="^blockParams.Style.int(1)"
			^if(def ^blockFields.data_process_id.int(0)){process="$blockFields.data_process_id"}
		>$blockData</block>
	}
	^if(^blockParams.Cache.int(0)){
		<!-- ^MAIN:dtNow.sql-string[] Begin Block Cache key: blocks_code_${blockFields.id}, cache time: $blockParams.Cache secs -->
		^cache[${MAIN:CacheDir}sql/blocks_code_${blockFields.id}.cache]($blockParams.Cache){$_cBlock}
		<!-- ^MAIN:dtNow.sql-string[] Ended Block Cache key: blocks_code_${blockFields.id}, cache time: $blockParams.Cache secs -->
	}{
		$_cBlock
	}
]
#end @printBlock[blockFields]

#################################################################################################
# "Пост" обработка блока
@parseBlockPostProcess[hBlockParams;sBlockData]
# =debug - не нравится мне это все
# в параметрах блока можно запретить постпроцесс блока 
^if(^hBlockParams.PostProcess.int(1)){

#	-------------------------------------------------------------------------------------------------------------------------------------
#	здесь процесятся виртуальные объекты             		
#	-------------------------------------------------------------------------------------------------------------------------------------
#	{$system/name/key/field}
	$sBlockData[^sBlockData.match[\{\^$system/([^^/]+)/([^^/]+)/([^^\}]+)\}][gi]{^getSystemObject[$match.1;$match.2;$match.3]}]
#	<system:value name="" key="" field=""/>
	$sBlockData[^sBlockData.match[<system:value name="([^^"]+)" key="([^^"]+)" field="([^^"]+)"/>][gi]{^getSystemObject[$match.1;$match.2;$match.3]}]
#	-------------------------------------------------------------------------------------------------------------------------------------

#	-------------------------------------------------------------------------------------------------------------------------------------
#	здесь процесятся виртуальные методы              <system:method name="">param</system:method>		
#	-------------------------------------------------------------------------------------------------------------------------------------
	$sBlockData[^sBlockData.match[<system:method name="([^^"]+)">([^^<]*)</system:method>][gi]{^getSystemMethod[$match.1;$match.2]}]
#	-------------------------------------------------------------------------------------------------------------------------------------

#	<mouse name="rules"></mouse>
}
$result[$sBlockData]
#end @parseBlockPostProcess[]

##################################################################################################
##                                                                                              ##
##                  ВИРТУАЛЬНЫЕ МЕТОДЫ                                                          ##
##                                                                                              ##
##################################################################################################
# ------------------------------------------------------------------------------------------------
#                   ФАБРИКИ
# ------------------------------------------------------------------------------------------------
# обработка параметров
@getSystemParams[sParams][_hParams]
$_tDub[^sParams.split[^]]]
^_tDub.append{^taint[^#0A]}
$result[^getParams[]]
#end @getSystemParams[sParams]
@getParams[name;value]
$result[
	^hash::create[
		^if(def $name && def $value){$.[$name][$value]}
		^while(def ^_tDub.piece.trim[start; 	^taint[^#0A]]){
			$_tTemp[^_tDub.piece.split[^[;h]]
			^_tDub.offset(1)
			$.[^_tTemp.0.trim[start; 	^taint[^#0A]]][^if(def $_tTemp.2){^getParams[^_tTemp.1.trim[start; 	^taint[^#0A]];$_tTemp.2]^_tDub.offset(1)}{$_tTemp.1}]
		}
	]
]
#end @getParams[name;value]

#################################################################################################
# виртуальная фабрика методов
@getSystemMethod[sName;sParams][_jMethod;_hParams]
$result[
	$_jMethod[$$sName] 
	^_jMethod[^getSystemParams[$sParams]]
]
#end @getSystemParser[sName;sParams]

#################################################################################################
# виртуальная фабрика объектов
@getSystemObject[sName;sKey;sField][_sField]
$_sField[$sKey]
	^switch[$sName]{
		^case[parser]{$result[^getParser[$sKey;$sField]]}
		^case[auth]{$result[$MAIN:objAuth.[$sKey].[$sField]]}
		^case[DEFAULT]{$result[^if(^sKey.int(0)){$[$sName].[$sKey].[$sField]}{$[$sName].[$form:[$_sField]].[$sField]}]}
}
#end @getSystemObject[sName;sKey;sField]
@getParser[sName;sField]
$result[^switch[$sName]{
	^case[request]{$request:[$sField]}
	^case[response]{$response:[$sField]}
	^case[form]{^if($sField eq 'all'){^form:fields.foreach[key;value]{$key=$value&}}{$form:[$sField]}}
	^case[env]{$env:[$sField]}
	^case[date]{^MAIN:dtNow.sql-string[]}
	^case[DEFAULT]{}}]
#end @getParser[sName;sField]

# ------------------------------------------------------------------------------------------------
#                   ОСНОВНЫЕ ВИРТУАЛЬНЫЕ МЕТОДЫ
# ------------------------------------------------------------------------------------------------
#################################################################################################
# вывод дерева объектов
@tree[hParam]
$result[^ObjectByParent[$[$hParam.hash_name];$hParam.thread_id;$.description[1]]]
#end @Tree[hParam]

#################################################################################################
# вывод полей объектов
@list[hParam][_jMethod]
$result[
^try{
  $_jMethod[$[$hParam.name]]
  ^_jMethod.menu{<$hParam.tag id="$_jMethod.id" value="$_jMethod.id"
	^if(def $hParam.mode){mode="$_jMethod.[$hParam.mode]"}
  	$hParam.added
	>$_jMethod.name</$hParam.tag> }
}{ $exception.handled(1) }
]
#end @list[hParam]

#################################################################################################
# получение и создание объека
@sql[hParam][_jMethod]
^try{
# 	получаем метод для создания объекта
	$_jMethod[$[${hParam.method}]]
# 	создаем объект
	$[${hParam.name}][^_jMethod[$.where[${hParam.where}]]]
}{$exception.handled(1)}
$result[]
#end @sql[hParam]

#################################################################################################
# обработка условий
@select[hParam][_jMethod]
$result[^if(${hParam.name} eq ${hParam.value}){${hParam.true}}{${hParam.false}}]
#end @sql[hParam]

#################################################################################################
# вызов любого определенного обработчика
@executeSystemProcess[hParam][_jMethod]
$result[^executeBlock[$hParam.id;$hParam.body;$hParam.param;$hParam.field]]
#end @process[hParam][_jMethod]

##################################################################################################
##                                                                                              ##
##                  РАБОТА С ОБРАБОТЧИКАМИ                                                      ##
##                                                                                              ##
##################################################################################################

#################################################################################################
# запус обработчиков объектов
# в принципе, то-же самое что executeBlock, но обработчику объекта может сваиться от передачи ему пустых параметров :) 
@executeProcess[dataProcessID]
# подготовка обработчика к использованию
^prepareProcesess[$dataProcessID]
# запуск обработчика
^if($PROCESSES_HASH.[$dataProcessID].main is junction){
# запуск обработчика
	$result[^PROCESSES_HASH.[$dataProcessID].main[]]
}{
#	нухно убрать кактус с подоконника
	$result[]
}
#end @executeProcess[]

#################################################################################################
# запуск обработчиков блоков
@executeBlock[dataProcessID;blockParam;blockBody;blockFields]
# подготовка обработчика к использованию
^prepareProcesess[$dataProcessID]
# запуск обработчика
^if($PROCESSES_HASH.[$dataProcessID].main is junction){
	$result[^PROCESSES_HASH.[$dataProcessID].main[
		$.param[$blockParam]
		$.body[$blockBody]
		$.table[$blockFields]
		]]
}{
	$result[]
}
#end @executeBlock[]


#################################################################################################
# грузит + кеширует + процессит + исполняет код обработчика
@prepareProcesess[dataProcessID][dataProcessMain;dataProcessFileName;dataProcessFile;dataProcessBody]
# обработчик может быть еще не загружен
^if(!$PROCESSES_HASH.[$dataProcessID].processBodyLoaded){
#	замена имени @main[...] обработчика
	$dataProcessMain[process_${dataProcessID}_main]
	^try{
#		полный путь до обработчика
		$dataProcessFileName[${MAIN:ProcessDir}$PROCESSES_HASH.[$dataProcessID].filename]
		$dataProcessFile[^file::load[text;$dataProcessFileName]]
#		тело обработчика
		$dataProcessBody[^taint[as-is][$dataProcessFile.text]]
	
#		компиляция обработчика в текущем (класс engine) контексте

		^process{@${dataProcessMain}^[lparams]
			$dataProcessBody}[
			$.main[$dataProcessMain]
			$.file[$dataProcessFileName]
		]
					
#		добавление информации в хеш о main dataProcess
		$PROCESSES_HASH.[$dataProcessID].main[$$dataProcessMain]
	}{
#		что-то случилось при чтении и компиляции
#		для использования в debug целях закомментировать
		$exception.handled(1)
	}
#	в любом случае сохранить, что была предзагрузка
#	никогда не приведет к повторной компиляции обработчика
	$PROCESSES_HASH.[$dataProcessID].processBodyLoaded(1)
}


##################################################################################################
##                                                                                              ##
##                  ПРОЧЕЕ                                                                      ##
##                                                                                              ##
##################################################################################################

#################################################################################################
# А дальше будут деревья чтоб их разорвало
@ObjectByParent[lparams;parent_id;params][tblLvlObj;_hParams]
$_hParams[^hash::create[$params]]
^if($_hParams.level){^_hParams.level.inc(1)}{$_hParams.level(1)}
# есть ли дети у родителя?
^if($lparams.[$parent_id]){
# получаем таблицу детей родителя
  $tblLvlObj[$lparams.[$parent_id]]
#   и смотрим что у нас у каждого ребенка
    ^tblLvlObj.menu{
		^printItem[$tblLvlObj.fields;^if($lparams.[$tblLvlObj.id]){^ObjectByParent[$lparams;$tblLvlObj.id;$_hParams]};$_hParams]
    }
    ^_hParams.level.dec(1)
}


#################################################################################################
# вывод ветви дерева xml
@printItem[itemHash;childItems;lparams]
$result[<branche id="$itemHash.id" name="$itemHash.name" level="$lparams.level"
	^if(def $lparams.parent_id){ parent_id="$itemHash.parent_id"}
	^if(def $lparams.thread_id){ thread_id="$itemHash.thread_id"}
	^if(def $lparams.window_name){ window_name="^if(def $itemHash.window_name){$itemHash.window_name}{$itemHash.name}"}
	^if(def $lparams.document_name){ document_name="^if(def $itemHash.document_name){$itemHash.document_name}{$itemHash.name}"}
	^if(def $lparams.description){ description="$itemHash.description"}
	^if($itemHash.id == $OBJECT.id){ in="1" 
			^if(def $form:year){
				hit="0"
			}{
				hit="1"
			}
		}
	is_show_on_menu="^itemHash.is_show_in_menu.int(0)" 
	is_show_on_site_map="^itemHash.is_show_on_sitemap.int(0)" 
	path="^if(def $itemHash.url){$itemHash.url}{$itemHash.full_path}"
	^if(def $lparams.added){$lparams.added}
	>$childItems</branche>]
#end @printItem[itemHash;childItems;lparams]

#################################################################################################
# Удаление файлов кэша начинающихся с заданного имени
@DeleteFiles[sDir;sName]
^try{
#	получаем и пытаемся удалить файл
	$_tList[^file:list[$sDir;${sName}_*[^^\.]*\.cache^$]] 
	^_tList.menu{^file:delete[${sDir}$_tList.name]} 
}{
#	если что то не так.. а да и фиг с ним!
	$exception.handled(1)
}
#end @DeleteFiles[sDir;sName]

#################################################################################################
# преобразование числа прав к хэшу прав
@getHashRights[iRights]
$result[^hash::create[
	$.read($iRights & 1)
	$.edit($iRights & 2)
	$.delete($iRights & 4)
	$.comment($iRights & 8)
	$.supervisory($iRights & 128)
]]
#end @getRights[iRights]

#################################################################################################
# преобразование хэша прав к числу прав
@getIntRights[hRights]
$result($hRights.read + $hRights.edit + $hRights.delete + $hRights.comment + $hRights.supervisory)
#end @getIntRights[hRights]

#################################################################################################
# получение полного пути объекта
@getFullPath[_iParentId;_sPath]
$result[^if(^_iParentId.int(0)){$OBJECTS_HASH.[$_iParentId].full_path}{/}$_sPath/]
#end @getFullPath[_iParentId;_sPath]

#################################################################################################
# получение ветви объекта
@getThreadId[_iParentId;_iId]
$result[^if(^_iParentId.int(0)){$OBJECTS_HASH.[$_iParentId].thread_id}{^OBJECTS_HASH.[$_iId].id.int(0)}]
#end @getThreadId[_iParentId]

#################################################################################################
# Набор HTML entities - надо т.к. в XML могут встречаться эти хуёвины
@entitySet[]
<!-- Character entity references for ISO 8859-1 characters -->
<!ENTITY nbsp   "&#160;">
<!ENTITY sect   "&#167;" >
<!ENTITY copy   "&#169;">
<!ENTITY laquo  "&#171;">
<!ENTITY reg    "&#174;">
<!ENTITY deg    "&#176;">
<!ENTITY plusmn "&#177;">
<!ENTITY para   "&#182;">
<!ENTITY raquo  "&#187;">
<!ENTITY times  "&#215;">
<!-- Character entity references for symbols, mathematical symbols, and Greek letters -->
<!ENTITY bull   "&#8226;">
<!ENTITY hellip "&#8230;">
<!-- Character entity references for markup-significant and internationalization characters -->
<!ENTITY ndash  "&#8211;">
<!ENTITY mdash  "&#8212;">
<!ENTITY lsquo  "&#8216;">
<!ENTITY rsquo  "&#8217;">
<!ENTITY sbquo  "&#8218;">
<!ENTITY ldquo  "&#8220;">
<!ENTITY rdquo  "&#8221;">
<!ENTITY bdquo  "&#8222;">
<!ENTITY lsaquo "&#8249;">
<!ENTITY rsaquo "&#8250;" >
<!ENTITY euro   "&#8364;">
<!ENTITY amp    "&#38;">
<!ENTITY lt     "&#60;">
<!ENTITY gt     "&#62;">
#end @entitySet[]

##################################################################################################
##
##                  SQL ЗАПРОСЫ
##
##################################################################################################
# метод формирующий и выполняющий sql запрос
@getSql[hParams]
$_hParams[^hash::create[$hParams]]
$result[
	^MAIN:objSQL.sql[table][
		SELECT
			^_hParams.names.foreach[key;value]{$key ^if(def $value){ AS $value }}[,]
		FROM
			$_hParams.table
		^if(def $_hParams.leftjoin){ LEFT JOIN $_hParams.leftjoin USING ($_hParams.using) }
		^if(def $_hParams.where){ WHERE $_hParams.where }
		^if(def $_hParams.group){GROUP BY $_hParams.group }
		^if(def $_hParams.order){ORDER BY $_hParams.order }
		^if(def $_hParams.having){HAVING $_hParams.having }
	][
		^if(def $_hParams.limit){$.limit($_hParams.limit)}
		^if(def $_hParams.offset){$.offset($_hParams.offset)}
	][
		^if(!$MAIN:NoCache){$.file[${_hParams.cache}.cache]}]
	]
]
#end @getSql[hParams]

#################################################################################################
# забирает из sql таблицу с зарегистрированнными сайтами
@getSITES[lparams]
$result[
	^getSql[
		$.table[m_site]
		$.where[$lparams.where]
		$.names[^hash::create[
			$.[m_site.site_id][id]
			$.[m_site.name][]
			$.[m_site.lang_id][]
			$.[m_site.domain][]
			$.[m_site.e404_object_id][]
			$.[m_site.cache_time][]
			$.[m_site.sort_order][]
		]]
		$.order[sort_order]
		$.cache[sites]
	]
]
#end @getSITES[]

#################################################################################################
# забирает объекты 
@getOBJECTS[lparams]
$result[
	^getSql[
		$.names[^hash::create[
			$.[m_object.object_id][id]
			$.[m_object.sort_order][]
			$.[m_object.parent_id][]
			$.[m_object.thread_id][]
			$.[m_object.object_type_id][]
			$.[m_object.template_id][]
			$.[m_object.data_process_id][]
			$.[m_object.link_to_object_type_id][]
			$.[m_object.link_to_object_id][]
			$.[m_object.auser_id][]
			$.[m_object.rights][]
			$.[m_object.cache_time][]
			$.[m_object.url][]
			$.[m_object.is_show_on_sitemap][]
			$.[m_object.is_show_in_menu][]
			$.[m_object.full_path][]
			$.[m_object.name][]
			$.[m_object.document_name][]
			$.[m_object.window_name][]
			$.[m_object.description][]
		]]
		$.table[m_object]
		$.where[$lparams.where]
		$.order[sort_order]
		$.cache[objects_${SYSTEM.siteID}]
	]
]
#end @getOBJECTS[lparams]

#################################################################################################
# забирает из sql все зарегистрированные шаблоны
@getTEMPLATES[lparams]
$result[
	^getSql[
		$.table[m_template]
		$.where[$lparams.where]
		$.names[^hash::create[
			$.[m_template.template_id][id]
			$.[m_template.template_type_id][]
			$.[m_template.name][]
			$.[m_template.description][]
			$.[m_template.filename][]
			$.[m_template.params][]
			$.[m_template.dt_update][]
			$.[m_template.sort_order][]
		]]
		$.order[sort_order]
		$.cache[templates]
	]
]
#end @getTEMPLATES[]

#################################################################################################
# метод достает все блоки объекта 
@getBLOCK_TO_OBJECT[lparams]
$result[
	^getSql[
		$.table[m_block_to_object]
		$.leftjoin[m_block]
		$.using[block_id]
		$.where[$lparams.where]
		$.names[^hash::create[
			$.[m_block.block_id][id]
			$.[m_block_to_object.sort_order][]
			$.[m_block_to_object.mode][]
			$.[m_block.data_process_id][]
			$.[m_block.name][]
			$.[m_block.attr][]
			$.[m_block.data][]
			$.[m_block.data_type_id][]
			$.[m_block.is_not_empty][]
			$.[m_block.is_parsed_manual][]
		]]
		$.order[sort_order]
		$.cache[blocks_${OBJECT.id}]
	]
]
#end @getBlocks[]

#################################################################################################
# забирает из sql все зарегистрированные обработчики
@getPROCESSES[lparams]
$result[
	^getSql[
		$.table[m_data_process]
		$.where[$lparams.where]
		$.names[^hash::create[
			$.[m_data_process.data_process_id][id]
			$.[m_data_process.data_process_type_id][]
			$.[m_data_process.name][]
			$.[m_data_process.description][]
			$.[m_data_process.filename][]
			$.[m_data_process.dt_update][]
			$.[m_data_process.sort_order][]
		]]
		$.order[sort_order]
		$.cache[process]
	]
]
#end @getPROCESSES[lparams]


#################################################################################################
# Большая просьба не убирать эту строку :)                                                      #
# сирота лучше всех, я не прав, сирота повелительница полосатых досок, хао - я сказал!          #
#################################################################################################