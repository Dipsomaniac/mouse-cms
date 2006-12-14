####################################################################################################
# $Id: engine.p, 10:30 12.12.2006 KLeN Exp $
# Класс построения страницы
@CLASS
engine



####################################################################################################
# Конструктор инициализация и выполнение engine
@init[]
# получаем ВСЕ сайты
$SITES[^getSITES[]]
$SITES_HASH[^SITES.hash[id]]
# получение ID сайта и ID языка сайта =debug а если такого сайта нету?
^if(^SITES.locate[domain;$env:SERVER_NAME]){$siteID($SITES.id) $siteLangID($SITES.lang_id)}
$SYSTEM[
	$.siteUrl[$env:SERVER_NAME]
#	полный путь запрошенного объекта (/admin/index.html)
	$.fullPath[$request:uri]
#	$.path[$env:PATH_INFO]
#	путь до объекта без параметров
	$.path[$MAIN:sPath]
	$.siteID(^siteID.int(0))
#	=debug
	$.siteLangID(^siteLangID.int(0))
]
# ВСЕ ОПУБЛИКОВАННЫЕ объекты текущего сайта
$OBJECTS[^getOBJECTS[$.where[m_object.site_id ='$SYSTEM.siteID' AND m_object.is_published ='1']]]
$OBJECTS_HASH[^OBJECTS.hash[id]]
# обработчики и шаблоны получаем в любом случае
# таблица обработчиков
$PROCESSES[^getPROCESSES[]]
$PROCESSES_HASH[^PROCESSES.hash[id]]
# таблица шаблонов
$TEMPLATES[^getTEMPLATES[]]
$TEMPLATES_HASH[^TEMPLATES.hash[id]]
#end @init[]



####################################################################################################
# Обработка исскуственно сгенерированных ошибок CMS
# "Чух, чух, чух" - Поехали!
@execute[]
^try{$result[^create[]]}{
	^if(^exception.type.pos[cms] == 0){
# 		перехватываем и отправляем по адресу странице ошибок
		$exception.handled(1)
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
# end @execute[]



####################################################################################################
# создание объекта страницы и определение прав пользователя
@create[][RIGHTS;ACL]
# если зажжен флажок отсутствия кэш файла - создаем его
^if(^MAIN:bCacheFile.int(0)){^createCacheFile[]}
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
# права объекта по умолчанию
	$RIGHTS($OBJECT.rights)
	^if($MAIN:objAuth.is_logon){
#		достаем назначения прав текущему пользователю на все объекты треда
		$ACL[^MAIN:objAuth.getFullACL[$OBJECT_THREAD]]	
#		определяем права авторизированного пользователя на объект
		$RIGHTS(^MAIN:objAuth.getRightsToObject[$OBJECT;$OBJECT_THREAD;$ACL;^if($MAIN:objAuth.user.id == $OBJECT.auser_id){1}{0}])
	}
#	получаем хэш прав
	$HASH_RIGHTS[^getHashRights[$RIGHTS]]
#	определение необходимого content и выдача его содержимого
	^if($HASH_RIGHTS.read){
		$result[^contentSwitcher[]]
	}{
		^throw[cms.403;$uri;доступ к объекту запрещен]
	}
}
#end @create[][RIGHS;ACL]



####################################################################################################
# создание файла кэша
@createCacheFile[][tCache]
$tCache[^table::create{id	full_path	cache_time^#0A
^OBJECTS.menu{$OBJECTS.id	$OBJECTS.full_path	$OBJECTS.cache_time^#0A}}]
^tCache.save[${MAIN:CacheDir}_cache.cfg]
#end @createCacheFile[]



####################################################################################################
# развилка-переключатель xml <=> html
@contentSwitcher[][xDoc;sStylesheet]
# путь к стилю
$sStylesheet[^getStylesheet[]]
#	если задан обработчик объекта передаем ему управление
^if(^OBJECT.data_process_id.int(0)){
	$result[^executeProcess[$OBJECT.data_process_id]]
}{
# 	Xdoc сборка страницы
	$xDoc[^getDocumentXML[]]
# 	проверка строки запроса и наличия шаблона
	^if(^MAIN:hUserInfo.Query.pos[mode=xml] == -1 && def $sStylesheet){
#		получение XSLT шаблона =debug вывод на печать реализовать как то по другому чтоли
		^if($form:mode eq print){$sStylesheet[${MAIN:TemplateDir}print.xsl]}
#		Очистка памяти
		^clearMemory[]
#		XSLT трансформация
		$xDoc[^xDoc.transform[$sStylesheet]]
	}
	$result[^taint[optimized-as-is][^xDoc.string[]]]
}
# end @contentSwitcher[][xDoc;sStylesheet]


####################################################################################################
# создание документа на основе собранного xml
@getDocumentXML[]
$result[^xdoc::create{<?xml version="1.0" encoding="$request:charset"?>
<!DOCTYPE site_page [
	^getEntitySet[]
]>
<document xmlns:system="http://klen.zoxt.net/doc/" lang="$SYSTEM.siteLangID" server="$SYSTEM.siteUrl" template="^getStylesheet[]">
  ^getDocumentBodyDefault[]
</document>
}]
# end @documentXML[]



####################################################################################################
# очистка памяти перед результирующей трансформацией =debug
@clearMemory[]
# системные переменные
$SYSTEM[] $SITES[] $SITES_HASH
$OBJECT[] $OBJECTS_HASH[] $OBJECTS[] $OBJECT_THREAD[] $OBJECTS_HASH_TREE[]
$TYPES[] $TYPES_HASH[]
$TEMPLATES[] $TEMPLATES_HASH[]
$PROCESSES[] $PROCESSES_HASH[]
$ACL[] $ACL_HASH[]
$BLOCKS[] $BLOCKS_HASH[]
$TYPES[] $TYPES_HASH[]
$USERS[] $USERS_HASH[]
# очистка памяти
^memory:compact[]
#end @clearMemory[]



####################################################################################################
#создание XSLT обработчика
@getStylesheet[][sFileName]
# имя файла шаблона
$sFileName[${MAIN:TemplateDir}$TEMPLATES_HASH.[$OBJECT.template_id].filename]
^if(-f $sFileName){$result[$sFileName]}{$result[]}
#end @getStylesheet[][sFileName]



####################################################################################################
# default сборка тела xml документа
@getDocumentBodyDefault[]
$result[
<navigation>
#	создаем дерево навигации
	^ObjectByParent[$OBJECTS_HASH_TREE;0;
		$.tag[branche]
		$.attributes[^table::create{name^#OAid^#OAname^#OAdescription^#OAis_show_in_menu^#OAis_show_on_sitemap^#OAfull_path}]
		$.id($OBJECT.id)
		]
</navigation>
<body>
#	сборка блоков
	^getBlocks[]
</body>
<system>
	<!-- ID и URL сайта -->
	<site id="$SYSTEM.siteID">$SYSTEM.siteUrl</site>
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
]
#end @documentBodyDefault[]



####################################################################################################
# обработка блоков объекта
@getBlocks[][tBlocksNow]
# опубликованнные блоки текущего объекта и (=debug не работает подчиненных) подчиненных объектов предназначенные для автоматической обработки
$tBlocksNow[^getBLOCK_TO_OBJECT[$.where[
	object_id IN ( 
#		если тип объекта не "уникальный" =debug зачем я это сделал?
		^if($OBJECT.object_type_id != 3){
#			приходят блоки всех глобальных объектов
			^OBJECTS.menu{^if(^OBJECTS.object_type_id.int(0) == 2){$OBJECTS.id ,}}
		}
#		eсли определено поле link_to_object_id объект получит информацию другого объекта
		^if(^OBJECT.link_to_object_id.int(0)){	$OBJECT.link_to_object_id }{ $OBJECT.id }
	)
	AND m_block.is_published = 1 AND m_block.is_parsed_manual != 1]]]
$result[^tBlocksNow.menu{^getBlock[$tBlocksNow.fields]}]
#end @getBlocks[][tBlocksNow]



####################################################################################################
# Собираем блок
@getBlock[hBlockFields][hBlockParams;cBlock;sBlockData]
$result[
	$hBlockParams[^getSystemParams[$hBlockFields.attr]]
	$cBlock{
#	 	если блок не пустой парсим его данные =debug эта штука поважнее должна быть
		^if(^hBlockFields.is_not_empty.int(0)){$sBlockData[^taint[as-is][$hBlockFields.data]]}
#	 	передача управления обработчику блока (если есть)
		^if(^hBlockFields.data_process_id.int(0)){$sBlockData[^executeBlock[$hBlockFields.data_process_id;$hBlockParams;$sBlockData;$hBlockFields]]}
#	 	замена спец конструкций в теле блока
		^if(def $SYSTEM.postProcess){$hBlockParams.PostProcess($SYSTEM.postProcess)}
		$sBlockData[^parseBlockPostProcess[$hBlockParams;$sBlockData]]
#	 	и собираем фрагмент блока
	<block 
			id="$hBlockFields.id" 
			name="$hBlockFields.name" 
			mode="$hBlockFields.mode" 
			style="^hBlockParams.Style.int(1)"
			^if(def ^hBlockFields.data_process_id.int(0)){process="$hBlockFields.data_process_id"}
		>$sBlockData</block>
	}
	^if(^hBlockParams.Cache.int(0)){
		<!-- ^MAIN:dtNow.sql-string[] Begin Block Cache key: blocks_code_${hBlockFields.id}, cache time: $hBlockParams.Cache secs -->
		^cache[${MAIN:CacheDir}sql/blocks_code_${hBlockFields.id}.cache]($hBlockParams.Cache){$cBlock}
		<!-- ^MAIN:dtNow.sql-string[] Ended Block Cache key: blocks_code_${hBlockFields.id}, cache time: $hBlockParams.Cache secs -->
	}{
		$cBlock
	}
]
#end @printBlock[blockFields]



####################################################################################################
# "Пост" обработка блока
@parseBlockPostProcess[hBlockParams;sBlockData]
# =debug - не нравится мне это все 
# в параметрах блока можно запретить постпроцесс блока 
^if(^hBlockParams.PostProcess.int(1)){

#	здесь процесятся виртуальные объекты             		
#	{$system/name/key/field}
	$sBlockData[^sBlockData.match[\{\^$system/([^^/]+)/([^^/]+)/([^^\}]+)\}][gi]{^getSystemObject[$match.1;$match.2;$match.3]}]
#	<system:value name="" key="" field=""/>
	$sBlockData[^sBlockData.match[<system:value name="([^^"]+)" key="([^^"]+)" field="([^^"]+)"/>][gi]{^getSystemObject[$match.1;$match.2;$match.3]}]

#	здесь процесятся виртуальные методы              <system:method name="">param</system:method>		
	$sBlockData[^sBlockData.match[<system:method name="([^^"]+)">([^^<]*)</system:method>][gi]{^getSystemMethod[$match.1;$match.2]}]

#	<mouse name="rules"></mouse>
}
$result[$sBlockData]
#end @parseBlockPostProcess[]



####################################################################################################
# обработка параметров
@getSystemParams[sParams][_hParams]
$_tDub[^sParams.split[^]]]
^_tDub.append{^taint[^#0A]}
$result[^getParams[]]
#end @getSystemParams[sParams]



####################################################################################################
# обработка параметров
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



####################################################################################################
# виртуальная фабрика методов
@getSystemMethod[sName;sParams][_jMethod;_hParams]
$result[
	$_jMethod[$$sName] 
	^_jMethod[^getSystemParams[$sParams]]
]
#end @getSystemParser[sName;sParams]



####################################################################################################
# виртуальная фабрика объектов
@getSystemObject[sName;sKey;sField][_sField]
$_sField[$sKey]
	^switch[$sName]{
		^case[parser]{$result[^getParser[$sKey;$sField]]}
		^case[auth]{$result[$MAIN:objAuth.[$sKey].[$sField]]}
		^case[DEFAULT]{$result[^if(^sKey.int(0)){$[$sName].[$sKey].[$sField]}{$[$sName].[$form:[$_sField]].[$sField]}]}
}
#end @getSystemObject[sName;sKey;sField]



####################################################################################################
# получение системных значений
@getParser[sName;sField]
$result[^switch[$sName]{
	^case[request]{$request:[$sField]}
	^case[response]{$response:[$sField]}
	^case[form]{^if($sField eq 'all'){^form:fields.foreach[key;value]{$key=$value&}}{$form:[$sField]}}
	^case[env]{$env:[$sField]}
	^case[date]{^MAIN:dtNow.sql-string[]}
	^case[DEFAULT]{}}]
#end @getParser[sName;sField]



####################################################################################################
# вывод дерева объектов
@tree[hParam]
$result[^ObjectByParent[$[$hParam.hash_name];$hParam.thread_id;
		$.tag[branche]
		$.attributes[^table::create{name^#OAid^#OAname^#OAdescription^#OAis_show_in_menu^#OAis_show_on_sitemap^#OAfull_path}]
		$.id($OBJECT.id)
]
]]
#end @Tree[hParam]



####################################################################################################
# вывод полей объектов
@list[hParam][_jMethod]
$result[
^try{
  $_jMethod[$$hParam.name]
  ^_jMethod.menu{<$hParam.tag id="$_jMethod.id" value="$_jMethod.id"
	^if(def $hParam.mode){mode="$_jMethod.[$hParam.mode]"}
  	$hParam.added
	>$_jMethod.name</$hParam.tag> }
}{ $exception.handled(1) ^stop[comment: $hParam.name]}
]
#end @list[hParam]



####################################################################################################
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



####################################################################################################
# обработка условий
@select[hParam][_jMethod]
$result[^if(${hParam.name} eq ${hParam.value}){${hParam.true}}{${hParam.false}}]
#end @sql[hParam]



####################################################################################################
# вызов любого определенного обработчика
@executeSystemProcess[hParam][_jMethod]
$result[^executeBlock[$hParam.id;$hParam.param;$hParam.body;$hParam.field]]
#end @process[hParam][_jMethod]



####################################################################################################
# запуск обработчиков объектов
# в принципе, то-же самое что executeBlock, но обработчику объекта может сваиться от передачи ему пустых параметров :) 
@executeProcess[dataProcessID]
# подготовка обработчика к использованию
^prepareProcesess[$dataProcessID]
# запуск обработчика
^if($PROCESSES_HASH.[$dataProcessID].main is junction){
# запуск обработчика
	$result[^PROCESSES_HASH.[$dataProcessID].main[]]
}{
#	нужно убрать кактус с подоконника
	$result[]
}
#end @executeProcess[]



####################################################################################################
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



####################################################################################################
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



####################################################################################################
# А дальше будут деревья чтоб их разорвало
@ObjectByParent[lparams;parent_id;params][tblLvlObj;_hParams]
$_hParams[^hash::create[$params]]
# =debug - уровень подсчитывается но нигде не используется
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



####################################################################################################
# вывод ветви дерева xml
@printItem[itemHash;childItems;lparams]
$result[
<$lparams.tag 
	^lparams.attributes.menu{
		${lparams.attributes.name}="$itemHash.[$lparams.attributes.name]"
	}
	^if($itemHash.id == $lparams.id){ in="1" 
			^if(def $form:id){
				hit="0"
			}{
				hit="1"
			}
		}
		level="$lparams.level"
	^if(def $lparams.added){$lparams.added}
	>$childItems</$lparams.tag>]
#end @printItem[itemHash;childItems;lparams]



####################################################################################################
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



####################################################################################################
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



####################################################################################################
# преобразование хэша прав к числу прав
@getIntRights[hRights]
$result($hRights.read + $hRights.edit + $hRights.delete + $hRights.comment + $hRights.supervisory)
#end @getIntRights[hRights]



####################################################################################################
# получение полного пути объекта
@getFullPath[iParentId;sPath]
$result[^if(^iParentId.int(0)){$OBJECTS_HASH.[$iParentId].full_path}{/}$sPath]
$result[^if(def $sPath){$result/}{$result}]
#end @getFullPath[_iParentId;_sPath]



####################################################################################################
# получение ветви объекта
@getThreadId[_iParentId;_iId]
$result[^if(^_iParentId.int(0)){$OBJECTS_HASH.[$_iParentId].thread_id}{^OBJECTS_HASH.[$_iId].id.int(0)}]
#end @getThreadId[_iParentId]



####################################################################################################
# Набор HTML entities - надо т.к. в XML могут встречаться эти хуёвины
@getEntitySet[]
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
#end @getEntitySet[]



####################################################################################################
# метод формирующий и выполняющий sql запрос
@getSql[hParams]
$result[
	^MAIN:objSQL.sql[table][
		SELECT
			^hParams.names.foreach[key;value]{$key ^if(def $value){ AS $value }}[,]
		FROM
			$hParams.table
		^if(def $hParams.leftjoin){ LEFT JOIN $hParams.leftjoin USING ($hParams.using) }
		^if(def $hParams.where){ WHERE $hParams.where }
		^if(def $hParams.group){GROUP BY $hParams.group }
		^if(def $hParams.order){ORDER BY $hParams.order }
		^if(def $hParams.having){HAVING $hParams.having }
	][
		^if(def $hParams.limit){$.limit($hParams.limit)}
		^if(def $hParams.offset){$.offset($hParams.offset)}
	][
		^if(!$MAIN:NoCache && def $hParams.cache){$.file[${hParams.cache}.cache]}
	]
]
#end @getSql[hParams]



####################################################################################################
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



####################################################################################################
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



####################################################################################################
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



####################################################################################################
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



####################################################################################################
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



# Большая просьба не убирать эту строку :)
# сирота лучше всех, я не прав, сирота повелительница полосатых досок, хао - я сказал!