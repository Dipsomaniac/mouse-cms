####################################################################################################
# $Id: engine.p, 10:30 12.12.2006 KLeN Exp $
# Класс построения страницы
@CLASS
engine



####################################################################################################
# Конструктор инициализация и выполнение engine
@init[][siteID;siteLangID]
# языки и сайты
$crdLang[^mLoader[$.name[lang]]]
$crdSite[^mLoader[$.name[site]]]
# получение ID сайта и ID языка сайта =debug а если такого сайта нету?
^if(^crdSite.table.locate[domain;$env:SERVER_NAME]){$siteID($crdSite.table.id) $siteLangID($crdSite.table.lang_id)}
$SYSTEM[
	$.siteUrl[$env:SERVER_NAME]
	$.fullPath[$request:uri]
	$.path[$MAIN:sPath]
	$.siteID(^siteID.int(0))
	$.lang(^if(^crdLang.table.locate[abbr;$MAIN:hUserInfo.lang]){$crdLang.table.id}{$crdSite.hash.[^siteID.int(0)].lang_id})
	$.date[^MAIN:dtNow.sql-string[]]
]
# ВСЕ ОПУБЛИКОВАННЫЕ объекты текущего сайта с ПОЛЯМИ ТЕКУЩЕГО языка
$crdObject[^mLoader[
	$.name[object]
	$.where[site_id = $SYSTEM.siteID AND is_published = 1 ]
]]
# обработчики и шаблоны получаем в любом случае
$crdDataProcess[^mLoader[$.name[data_process]$.h(1)]]
$crdTemplate[^mLoader[$.name[template]$.h(1)]]
# устанавливаем заголовки ответа =debug разобраться с кешированием
$response:cache-control[no-store, no-cache]
$response:pragma[no-cache]
$request:charset[UTF-8]
$response:charset[$crdLang.hash.[$SYSTEM.lang].charset] 
$response:content-type[
	$.value[text/html]
   $.charset[$response:charset]
]
#end @init[]



####################################################################################################
# Обработка исскуственно сгенерированных ошибок CMS
# "Чух, чух, чух" - Поехали!
@execute[]
^try{
	$result[^create[]]
}{
	^if(^exception.type.pos[cms] == 0){
# 		перехватываем и отправляем по адресу странице ошибок
		$exception.handled(1)
		$result[
			^if(^crdObject.table.locate[id;$crdSite.hash.[$SYSTEM.siteID].e404_object_id]){
    			^location[$crdObject.table.full_path?error=$exception.type&url=$SYSTEM.path;$.is_external(1)]
			}{
				^throw[$exception.type;$env:SERVER_NAME;Страница ошибок не найдена ($exception.comment)]
			}
		]
	}{
#		если запрос не с локалхоста - прячем ошибку
		^if($MAIN:hUserInfo.Ip ne '127.0.0.1'){
			$exception.handled(1)
			Mouse error... (comment me) please <a href="mailto:horneds@gmail.com">mail to admin</a>
			^cache(0)
		}
	}
}
# end @execute[]



####################################################################################################
# создание объекта страницы и определение прав пользователя
@create[][iRights;ACL;tObjectThread]
# если зажжен флажок отсутствия кэш файла - создаем его
^if(^MAIN:bCacheFile.int(0)){^createCacheFile[]}
# проверка существования запрошенного объекта, существует - создаем, иначе отправка на страницу ошибок
^if(^crdObject.table.locate[full_path;$SYSTEM.path]){
	$hObjectNow[$crdObject.table.fields]
}{
	^throw[cms.404;$request:uri;Страница не найдена]
}
^if(def $hObjectNow.url){
#	если определено поле $hObjectNow.url - location по адресу 
	$result[^location[^taint[as-is][$hObjectNow.url]]]
}{
# 	ветвь текущего объекта
	$tObjectThread[^crdObject.table.select($crdObject.table.thread_id == $hObjectNow.thread_id)]
# права объекта по умолчанию
	$iRights($hObjectNow.rights)
	^if($MAIN:objAuth.is_logon){
#		достаем назначения прав текущему пользователю на все объекты треда
		$ACL[^MAIN:objAuth.getFullACL[$tObjectThread]]	
#		определяем права авторизированного пользователя на объект
		$iRights(^MAIN:objAuth.getRightsToObject[$hObjectNow;$tObjectThread;$ACL;^if($MAIN:objAuth.user.id == $hObjectNow.auser_id){1}{0}])
	}
#	получаем хэш прав
	$hRights[^getHashRights[$iRights]]
#	определение необходимого content и выдача его содержимого
	^if($hRights.read){
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
^crdObject.table.menu{$crdObject.table.id	$crdObject.table.full_path	$crdObject.table.cache_time^#0A}}]
^tCache.save[$MAIN:CacheDir/_cache.cfg]
#end @createCacheFile[]



####################################################################################################
# развилка-переключатель xml <=> html
@contentSwitcher[][xDoc;sStylesheet]
# путь к стилю
$sStylesheet[^getStylesheet[]]
#	если задан обработчик объекта передаем ему управление
^if(^hObjectNow.data_process_id.int(0)){
	$result[^executeProcess[$hObjectNow.data_process_id]]
}{
# 	Xdoc сборка страницы
	$xDoc[^getDocumentXML[]]
# 	проверка строки запроса и наличия шаблона
	^if(^MAIN:hUserInfo.Query.pos[mode=xml] == -1 && def $sStylesheet){
#		получение XSLT шаблона =debug вывод на печать реализовать как то по другому чтоли
		^if($form:mode eq print){$sStylesheet[$MAIN:TemplateDir/print.xsl]}
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
# =debug пространство имен system переименовать в mouse добавить поддержку многоязычности
<document xmlns:mouse="http://klen.zoxt.net/doc/" lang="$crdLang.hash.[$SYSTEM.siteLangID].abbr" server="$SYSTEM.siteUrl" template="^getStylesheet[]" charset="$crdLang.hash.[$SYSTEM.siteLangID].charset">
  ^getDocumentBodyDefault[]
</document>
}]
# end @documentXML[]



####################################################################################################
# очистка памяти перед результирующей трансформацией =debug
@clearMemory[]
$SYSTEM[]          $crdSite[]            $hObjectNow[]
$crdObject[]       $crdTemplate[]        $crdProcess[]
$crdBlock[]        $crdBlockToObject[]   $crdTemplate[]
$crdObjectType[]   $crdDataProcess[]     $crdAuser[]
$crdDataType[]     $crdDataProcessType[] $crdAuserToAuser[]
$crdAcl[]          $crdArticle[]         $crdArticleType[]
# очистка памяти
^memory:compact[]
#end @clearMemory[]



####################################################################################################
#создание XSLT обработчика
@getStylesheet[][sFileName;result]
# имя файла шаблона
$sFileName[$MAIN:TemplateDir/$crdTemplate.hash.[$hObjectNow.template_id].filename]
^if(-f $sFileName){$result[$sFileName]}{$result[]}
#end @getStylesheet[][sFileName]



####################################################################################################
# default сборка тела xml документа
@getDocumentBodyDefault[]
$result[
<navigation>
#	создаем дерево навигации
^crdObject.tree[$.id($hObjectNow.id)$.attributes[^table::create{name^#OAid^#OAname^#OAdescription^#OAis_show_in_menu^#OAis_show_on_sitemap^#OAfull_path}]]
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
	<datetime>$SYSTEM.date</datetime>
</system>
<header>
	<!-- ID объекта -->
	<object-id>$hObjectNow.id</object-id>
	<!-- ID родителя -->
	<parent-id>$hObjectNow.parent_id</parent-id>
	<!-- Имя XSLT шаблона -->
	<template>^getStylesheet[]</template>
	<!-- ID обработчика -->
	<data_process-id>$hObjectNow.data_process_id</data_process-id>
	<!-- ID типа объекта -->
	<object_type-id>$hObjectNow.object_type_id</object_type-id>
	<!-- ссылка на объект (ID) --> 
# 	=debug нет работы с типом ссылки (link_to_object_id_type)
	<link_to_object-id>$hObjectNow.link_to_object_id</link_to_object-id>
	<!-- имя объекта -->
	<name>$hObjectNow.name</name>
	<!-- title страницы -->
	<window_name>^if(def $hObjectNow.window_name){$hObjectNow.window_name}{$hObjectNow.name}</window_name>
	<!-- заголовок страницы -->
	<document_name>^if(def $hObjectNow.document_name){$hObjectNow.document_name}{$hObjectNow.name}</document_name>
	<!-- реальный объекта на сайте -->
	<full_path>$hObjectNow.full_path</full_path>
# 	=debug работа с кэшем не реализована
	<cache-time>$hObjectNow.cache_time</cache-time>
	<!-- основной файл стиля CSS -->
	<css source="$crdTemplate.hash.[$hObjectNow.template_id].params" />
#	<!-- keywords --> =debug
#	<keywords>^kewords[]</keywors>
</header>
]
#end @documentBodyDefault[]



####################################################################################################
# обработка блоков объекта
@getBlocks[][crdBlock]
# опубликованнные блоки текущего объекта и (=debug не работает подчиненных) подчиненных объектов предназначенные для автоматической обработки
$crdBlock[^mLoader[
	$.name[block_to_object]
	$.where[
		object_id IN ( 
#			если тип объекта не "уникальный" =debug зачем я это сделал?
			^if($hObjectNow.object_type_id != 3){
#				приходят блоки всех глобальных объектов
				^crdObject.table.menu{^if(^crdObject.table.object_type_id.int(0) == 2){$crdObject.table.id ,}}
			}
#			eсли определено поле link_to_object_id объект получит информацию другого объекта
			^if(^hObjectNow.link_to_object_id.int(0)){$hObjectNow.link_to_object_id }{ $hObjectNow.id }		
		)
		AND block.is_published = 1 AND block.is_parsed_manual != 1
	]
	$.t(1)
]]
$result[^crdBlock.table.menu{^getBlock[$crdBlock.table.fields]}]
#end @getBlocks[][tBlocksNow]



####################################################################################################
# Собираем блок
@getBlock[hBlockFields][hBlockParams;cBlock;sBlockData]
$result[
	$hBlockParams[^getStrToHash[$hBlockFields.attr]]
	$cBlock{
#	 	если блок не пустой парсим его данные =debug эта штука поважнее должна быть
		^if(^hBlockFields.is_not_empty.int(0)){$sBlockData[^taint[as-is][$hBlockFields.data]]}
#	 	передача управления обработчику блока (если есть)
		^if(^hBlockFields.data_process_id.int(0)){$sBlockData[^executeBlock[$hBlockFields.data_process_id;$hBlockParams;$sBlockData;$hBlockFields]]}
#	 	замена спец конструкций в теле блока
		^if(def $SYSTEM.postProcess){$hBlockParams.postProcess($SYSTEM.postProcess)}
		$sBlockData[^parseBlockPostProcess[$hBlockParams;$sBlockData]]
#	 	и собираем фрагмент блока
	<block 
			id="$hBlockFields.id" 
			name="$hBlockFields.name" 
			mode="$hBlockFields.mode" 
			style="^hBlockParams.style.int(1)"
			postProcess="^hBlockParams.postProcess.int(1)"
			^if(^hBlockFields.data_process_id.int(0)){process="$hBlockFields.data_process_id"}
		>$sBlockData</block>
	}
	^if(^hBlockParams.cache.int(0)){
		$hBlockParams.cache_file[$MAIN:CacheDir/block_code_^math:md5[${request:uri}${hBlockFields.id}].cache]
		<!-- $SYSTEM.date Begin Block Cache file: $hBlockParams.cache_file, cache time: $hBlockParams.cache secs -->
		^cache[$hBlockParams.cache_file]($hBlockParams.cache){$cBlock}
		<!-- $SYSTEM.date Ended Block Cache file: $hBlockParams.cache_file, cache time: $hBlockParams.cache secs -->
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
^if(^hBlockParams.postProcess.int(1)){
#	здесь процесятся виртуальные объекты             		
#	{$mouse/name/key/field}
	$sBlockData[^sBlockData.match[\{\^$mouse/([^^/]+)/([^^/]+)/([^^\}]+)\}][gi]{^getSystemObject[$match.1;$match.2;$match.3]}]
#	<mouse:value name="" key="" field=""/>
	$sBlockData[^sBlockData.match[<mouse:value name="([^^"]+)" key="([^^"]+)" field="([^^"]+)"/>][gi]{^getSystemObject[$match.1;$match.2;$match.3]}]

#	> 
#	здесь процесятся виртуальные методы              <mouse:method name="">param</system:method>		
	$sBlockData[^sBlockData.match[<mouse:method name="([^^"]+)">([^^<]*)</mouse:method>][gi]{^getSystemMethod[$match.1;$match.2]}]

#	>
}
$result[$sBlockData]
#end @parseBlockPostProcess[]



####################################################################################################
# виртуальная фабрика методов =debug не проверено на курдах
@getSystemMethod[sName;sParams][result;jMethod]
$result[
	$jMethod[$$sName] 
	^jMethod[^getStrToHash[$sParams]]
]
#end @getSystemParser[sName;sParams]



####################################################################################################
# виртуальная фабрика объектов =debug не проверено на курдах
@getSystemObject[sName;sKey;sField][result;_sField]
$_sField[$sKey]
	^switch[$sName]{
		^case[parser]{$result[^getParser[$sKey;$sField]]}
		^case[auth]{$result[$MAIN:objAuth.[$sKey].[$sField]]}
		^case[DEFAULT]{$result[^if(^sKey.int(0)){$[$sName].hash.$sKey.$sField}{$[$sName].hash.$form:[$_sField].$sField}]}
}
#end @getSystemObject[sName;sKey;sField]



####################################################################################################
# получение системных значений =debug не проверено на курдах
@getParser[sName;sField][result]
$result[^switch[$sName]{
	^case[request]{$request:[$sField]}
	^case[response]{$response:[$sField]}
	^case[form]{^if($sField eq 'all'){^form:fields.foreach[key;value]{$key=$value&amp^;}}{$form:[$sField]}}
	^case[env]{$env:[$sField]}
	^case[date]{$SYSTEM.date}
	^case[DEFAULT]{}}]
#end @getParser[sName;sField]



####################################################################################################
# вывод дерева объектов
@tree[hParam][result;jMethod]
$result[
$jMethod[$[$hParam.name]]
^jMethod.tree[$.attributes[^table::create{name^#OAid^#OAname^#OAdescription^#OAis_show_in_menu^#OAis_show_on_sitemap^#OAfull_path}]]
]
#end @Tree[hParam]



####################################################################################################
# вывод полей объектов =debug не проверено на курдах
@list[hParam][_jMethod]
$result[
$jMethod[$[$hParam.name]]
^jMethod.list[$hParam.params]
]
#end @list[hParam]



####################################################################################################
# обработка условий
@select[hParam]
$result[^if(${hParam.name} eq ${hParam.value}){${hParam.true}}{${hParam.false}}]
#end @select[hParam]



####################################################################################################
# вызов любого определенного обработчика
@executeSystemProcess[hParam]
$result[^executeBlock[$hParam.id;$hParam.param;$hParam.body;$hParam.field]]
#end @executeSystemProcess[hParam]



####################################################################################################
# запуск обработчиков объектов
# в принципе, то-же самое что executeBlock, но обработчику объекта может сваиться от передачи ему пустых параметров :) 
@executeProcess[dataProcessID]
# подготовка обработчика к использованию
^prepareProcesess[$dataProcessID]
# запуск обработчика
^if($crdDataProcess.hash.[$dataProcessID].main is junction){
# запуск обработчика
	$result[^crdDataProcess.hash.[$dataProcessID].main[]]
}{
#	нужно убрать кактус с подоконника
	$result[]
}
#end @executeProcess[dataProcessID]



####################################################################################################
# запуск обработчиков блоков
@executeBlock[dataProcessID;blockParam;blockBody;blockFields]
# подготовка обработчика к использованию
^prepareProcesess[$dataProcessID]
# запуск обработчика
^if($crdDataProcess.hash.[$dataProcessID].main is junction){
	$result[^crdDataProcess.hash.[$dataProcessID].main[
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
^if(!$crdDataProcess.hash.[$dataProcessID].processBodyLoaded){
#	замена имени @main[...] обработчика
	$dataProcessMain[process_${dataProcessID}_main]
	^try{
#		полный путь до обработчика
		$dataProcessFileName[$MAIN:ProcessDir/$crdDataProcess.hash.[$dataProcessID].filename]
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
		$crdDataProcess.hash.[$dataProcessID].main[$$dataProcessMain]
	}{
#		что-то случилось при чтении и компиляции
#		для использования в debug целях закомментировать
		$exception.handled(1)
	}
#	в любом случае сохранить, что была предзагрузка
#	никогда не приведет к повторной компиляции обработчика
	$crdDataProcess.hash.[$dataProcessID].processBodyLoaded(1)
}
#end @prepareProcesess[dataProcessID][dataProcessMain;dataProcessFileName;dataProcessFile;dataProcessBody]



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



#################################################################################################
# Загрузчик курдов
@mLoader[hParams]
$result[
	^curd::init[
		$.name[$hParams.name]
		$.where[$hParams.where]
		$.limit($hParams.limit)
		$.offset($hParams.offset)
		$.h($hParams.h)
		$.t($hParams.t)
		^switch[$hParams.name]{
#			языки
			^case[lang]{
				$.names[
					$.[lang.lang_id][id]
					$.[lang.sort_order][]
					$.[lang.abbr][]
					$.[lang.charset][]
				]
			}
#			сайты
			^case[site]{
				$.names[
					$.[site.site_id][id]
					$.[site.name][]
					$.[site.lang_id][]
					$.[site.domain][]
					$.[site.e404_object_id][]
					$.[site.cache_time][]
					$.[site.sort_order][]
				]
			}
#			объекты
			^case[object]{
				$.leftjoin[object_text]
				$.on[object.object_id = object_text.object_id AND object_text.lang_id = $SYSTEM.lang]
				$.names[
					$.[object.object_id][id]
					$.[object.sort_order][]
					$.[object.parent_id][]
					$.[object.thread_id][]
					$.[object.object_type_id][]
					$.[object.template_id][]
					$.[object.data_process_id][]
					$.[object.link_to_object_type_id][]
					$.[object.link_to_object_id][]
					$.[object.auser_id][]
					$.[object.rights][]
					$.[object.cache_time][]
					$.[object.url][]
					$.[object.is_show_on_sitemap][]
					$.[object.is_show_in_menu][]
					$.[object.full_path][]
					$.[object_text.name][]
					$.[object_text.document_name][]
					$.[object_text.window_name][]
					$.[object_text.description][]
				]
			}
#			обработчики
			^case[data_process]{
				$.names[
					$.[data_process.data_process_id][id]
					$.[data_process.data_process_type_id][]
					$.[data_process.name][]
					$.[data_process.description][]
					$.[data_process.filename][]
					$.[data_process.dt_update][]
					$.[data_process.sort_order][]
				]
			}
#			шаблоны
			^case[template]{
				$.names[
					$.[template.template_id][id]
					$.[template.template_type_id][]
					$.[template.name][]
					$.[template.description][]
					$.[template.filename][]
					$.[template.params][]
					$.[template.dt_update][]
					$.[template.sort_order][]
				]
			}
#			блоки объекта
			^case[block_to_object]{
				$.leftjoin[block]
				$.using[block_id]
				$.names[
					$.[block.block_id][id]
					$.[block_to_object.sort_order][]
					$.[block_to_object.mode][]
					$.[block.data_process_id][]
					$.[block.name][]
					$.[block.attr][]
					$.[block.data][]
					$.[block.data_type_id][]
					$.[block.is_not_empty][]
					$.[block.is_parsed_manual][]
				]
			}
		}
	]
]
#end @mLoader[hParams]



# Большая просьба не убирать эту строку :)
# сирота лучше всех, я не прав, сирота повелительница полосатых досок, хао - я сказал!