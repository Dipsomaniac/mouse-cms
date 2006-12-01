@CLASS
engine

#################################################################################################
#                                                                                               #
#      �������������   �����   �����������   �������   ��������� ���������                      #
#                                                                                               #
#################################################################################################
# ����������� ������������� � ���������� engine
@init[][siteID;suteLangID]
# �������� ��� �����
$SITES[^getSITES[]]
$SITES_HASH[^SITES.hash[id]]
# ��������� ID ����� � ID ����� ����� =debug � ���� ������ ����� ����?
^if(^SITES.locate[domain;$env:SERVER_NAME]){$siteID($SITES.id) $siteLangID($SITES.lang_id)}
$SYSTEM[
	$.SiteUrl[$env:SERVER_NAME]
#	������ ���� ������������ ������� (/admin/index.html)
	$.fullPath[$request:uri]
#	���� �������
#	$.path[$env:PATH_INFO]
	$.path[$MAIN:sPath]
	$.siteID(^siteID.int(0))
	$.siteLangID(^siteLangID.int(0)) #=debug
]
# �������� ��� �������������� ������� �������� �����
$OBJECTS[^getOBJECTS[$.where[m_object.site_id ='$SYSTEM.siteID' AND m_object.is_published ='1']]]
$OBJECTS_HASH[^OBJECTS.hash[id]]
# ����������� � ������� �������� � ����� ������
# ������� ������������
$PROCESSES[^getPROCESSES[]]
$PROCESSES_HASH[^PROCESSES.hash[id]]
# ������� ��������
$TEMPLATES[^getTEMPLATES[]]
$TEMPLATES_HASH[^TEMPLATES.hash[id]]
# ��� �������� ���������� �����
#end @init[]

#################################################################################################
#                                                                                               #
#      ������   ����������                                                                      #
#                                                                                               #
#################################################################################################
# "���, ���, ���" - �������!
@execute[][str]
^try{
#	���������� �������
	$result[^create[]]
}{
	$str[$exception.type]
	^if(^str.pos[cms] == 0){
# 		��������� ������������ ��������������� ������ ���
		$exception.handled(1)
# 		� ���������� �� ������
		$result[
  			^if(^OBJECTS.locate[id;$SITES_HASH.[$SYSTEM.siteID].e404_object_id]){
    				^location[$OBJECTS.full_path?error=$exception.type&url=$SYSTEM.path;$.is_external(1)]
			}{
				^throw[$exception.type;$env:SERVER_NAME;�������� ������ �� ������� ($exception.comment)]
			}
		]
#		$result[��������� ������ "$exception.type" - $exception.comment]
	}
}
# end @execute[][str]

#################################################################################################
#                                                                                               #
# �������   �����   ��� ������   ������� ������   ������ � ��������                             #
#                                                                                               #
#################################################################################################
# �������� �������� �����
@create[][ACL]
# ���� ������ ������ ���������� ��� ����� - ������� ���
^if($MAIN:bCacheFile){^createCacheFile[]}
# �������� ������������� ������������ �������, ���������� - �������, ����� �������� �� �������� ������
^OBJECTS.menu{^if($OBJECTS.full_path eq $SYSTEM.path){$OBJECT[$OBJECTS.fields]}}
^if(!def $OBJECT){^throw[cms.404;$request:uri;�������� �� �������]}
^if(def $OBJECT.url){
#	���� ���������� ���� $OBJECT.url - location �� ������ 
	$result[^location[^taint[as-is][$OBJECT.url]]]
}{
# 	����� �������� �������
	$OBJECT_THREAD[^OBJECTS.select($OBJECTS.thread_id == $OBJECT.thread_id)]
#	��� �������� �� parent_id (��� ������������ ���������)
	$OBJECTS_HASH_TREE[^OBJECTS.hash[parent_id][$.distinct[tables]]]
#	=debug ��� ����������� �������� ���� �� ������ 
	$RIGHTS($OBJECT.rights)
	^if($MAIN:objAuth.is_logon){
#		������� ���������� ���� �������� ������������ �� ��� ������� �����
		$ACL[^MAIN:objAuth.getFullACL[$OBJECT_THREAD]]
#		���������� ����� ����������������� ������������ �� ������
		$RIGHTS(^MAIN:objAuth.getRightsToObject[$OBJECT;$OBJECT_THREAD;$ACL;^if($MAIN:objAuth.user.id == $OBJECT.auser_id){1}{0}])
	}
	$HASH_RIGHTS[^getHashRights[$RIGHTS]]
#	����������� ������������ content � ������ ��� �����������
	^if($HASH_RIGHTS.read){
		$result[^contentSwitcher[]]
	}{
		^throw[cms.403;$uri;������ � ������� ��������]
	}
}
# end @create[][str]

#################################################################################################
# �������� ����� ����
@createCacheFile[][_tCache]
$_tCache[^table::create{id	full_path	cache_time
^OBJECTS.menu{$OBJECTS.id	$OBJECTS.full_path	$OBJECTS.cache_time
}}]
^_tCache.save[${MAIN:CacheDir}_cache.cfg]
#end @createCacheFile[]

#################################################################################################
# ��������-������������� xml <=> html
@contentSwitcher[][_xDoc;_sStylesheet]
# ��������� xml ����
$_xDoc[^getDocumentXML[]]
$_sStylesheet[^getStylesheet[]]
# �������� ������ �������
^if(!$MAIN:EngineXML){
#	��������� XSLT ������� =debug ����� �� ������ ����������� ��� �� �� ������� �����
	^if($form:mode eq print){$_sStylesheet[${MAIN:TemplateDir}print.xsl]}
#	������� ������
	^clearMemory[]
#	XSLT �������������
	$_xDoc[^_xDoc.transform[$_sStylesheet]]
}
$result[^_xDoc.string[]]
# end @contentSwitcher[][doc;stylesheet]

#################################################################################################
# ������� ������ ����� �������������� �������������� =work
@clearMemory[]
# ��������� ����������
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
# ������� ������
^memory:compact[]
#end @clearMemory[]

#################################################################################################
#�������� XSLT �����������
@getStylesheet[][_sFileName]
# ��� ����� �������
$_sFileName[${MAIN:TemplateDir}$TEMPLATES_HASH.[$OBJECT.template_id].filename]
^if(-f $_sFileName){
#	result - ������ ���� + ��� �������
	$result[$_sFileName]
}{
#	������, ��� ������� �� ����� XSLT ������
	^throw[cms.500;$_sFileName;��� ������� �� ����� XSLT ������]
}
#end @getStylesheet[]

#################################################################################################
# �������� ��������� �� ������ ���������� xml
# �� � ��� ������� ����
@getDocumentXML[]
$result[^xdoc::create{<?xml version="1.0" encoding="$request:charset"?>
<!DOCTYPE site_page [
	^entitySet[]
]>
<document lang="$SYSTEM.siteLangID" server="$env:SERVER_NAME" template="^getStylesheet[]">
  ^getDocumentBody[]
</document>
}]
# end @documentXML[]

#################################################################################################
# ������ xml ���������
# � ������, ���� ��������� ���������� - ��������� ��������� ���������� ��� -
# ���������� ��������� ���� � ������, ���������� ��� @default_body[]
# � ��������� ������ - ���� default ������, ���������� � ����������
@getDocumentBody[]
^if(^OBJECT.data_process_id.int(0)){
#	�������� ���������� ����������� ������� 
	$result[^executeProcess[$OBJECT.data_process_id]]
}{
#	default ������
	$result[^getDocumentBodyDefault[]]
}
#end @documentBody[]

#################################################################################################
# default ������ ���� xml ���������
@getDocumentBodyDefault[]
$result[
<system>
	<!-- ID � URL ����� -->
	<site id="$SYSTEM.siteID">$SYSTEM.SiteUrl</site>
	<!-- ������������ URI -->
	<request-uri>$env:REQUEST_URI</request-uri>
	<!-- URI �������  -->
	<request-path>$SYSTEM.fullPath</request-path>
	<!-- QUERY �������  -->
	<request-query>$request:query</request-query>
	<!-- ���� � �����  -->
	<datetime>^MAIN:dtNow.sql-string[]</datetime>
</system>
<header>
	<!-- ID ������� -->
	<object-id>$OBJECT.id</object-id>
	<!-- ID �������� -->
	<parent-id>$OBJECT.parent_id</parent-id>
	<!-- ��� XSLT ������� -->
	<template>^getStylesheet[]</template>
	<!-- ID ����������� -->
	<data_process-id>$OBJECT.data_process_id</data_process-id>
	<!-- ID ���� ������� -->
	<object_type-id>$OBJECT.object_type_id</object_type-id>
	<!-- ������ �� ������ (ID) --> 
# 	=debug ��� ������ � ����� ������ (link_to_object_id_type)
	<link_to_object-id>$OBJECT.link_to_object_id</link_to_object-id>
	<!-- ��� ������� -->
	<name>$OBJECT.name</name>
	<!-- title �������� -->
	<window_name>^if(def $OBJECT.window_name){$OBJECT.window_name}{$OBJECT.name}</window_name>
	<!-- ��������� �������� -->
	<document_name>^if(def $OBJECT.document_name){$OBJECT.document_name}{$OBJECT.name}</document_name>
	<!-- �������� ������� �� ����� -->
	<full_path>$OBJECT.full_path</full_path>
# 	=debug ������ � ����� �� �����������
	<cache-time>$OBJECT.cache_time</cache-time>
	<!-- �������� ���� ����� CSS -->
	<css source="$TEMPLATES_HASH.[$OBJECT.template_id].params" />
#	<!-- keywords --> =debug
#	<keywords>^kewords[]</keywors>
</header>
<navigation>
#	������� ������ ���������
	^ObjectByParent[$OBJECTS_HASH_TREE;0;$.description[1]]
</navigation>
<body>
#	������ ������
	^getBlocks[]
</body>
]
#end @documentBodyDefault[]


##################################################################################################
##                                                                                              ##
## �����   �����������   ��������������                                                         ##
##                                                                                              ##
##################################################################################################
# ��������� ������ �������
@getBlocks[][BLOCKS]
# ��������������� ����� �������� ������� � (=debug �� �������� �����������) ����������� �������� ��������������� ��� �������������� ���������
$BLOCKS_NOW[^getBLOCK_TO_OBJECT[$.where[
	object_id IN ( 
#		���� ��� ������� �� "����������"
		^if($OBJECT.object_type_id != 3){
#			�������� ����� ���� ���������� ��������
			^OBJECTS.menu{^if(^OBJECTS.object_type_id.int(0) == 2){$OBJECTS.id ,}}
		}
#		e��� ���������� ���� link_to_object_id ������ ������� ���������� ������� �������
		^if(^OBJECT.link_to_object_id.int(0)){	$OBJECT.link_to_object_id }{ $OBJECT.id }
	)
	AND m_block.is_published = 1 AND m_block.is_parsed_manual != 1]]]
# ���������� ������ �� y
$result[^BLOCKS_NOW.menu{^getBlock[$BLOCKS_NOW.fields]}]
#end @parseDefaultBlocks[]

#################################################################################################
# �������� ����
@getBlock[blockFields][_cBlock;blockParams;blockData]
$result[
	$blockParams[^getSystemParams[$blockFields.attr]]
	$_cBlock{
#	 	���� ���� �� ������ ������ ��� ������ =debug ��� ����� �������� ������ ����
		^if(^blockFields.is_not_empty.int(0)){$blockData[^taint[as-is][$blockFields.data]]}
#	 	�������� ���������� ����������� ����� (���� ����)
		^if(^blockFields.data_process_id.int(0)){$blockData[^executeBlock[$blockFields.data_process_id;$blockParams;$blockData;$blockFields]]}
#	 	������ ���� ����������� � ���� �����
		$blockData[^parseBlockPostProcess[$blockParams;$blockData]]
#	 	� �������� �������� �����
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
# "����" ��������� �����
@parseBlockPostProcess[hBlockParams;sBlockData]
# =debug - �� �������� ��� ��� ���
# � ���������� ����� ����� ��������� ����������� ����� 
^if(^hBlockParams.PostProcess.int(1)){

#	-------------------------------------------------------------------------------------------------------------------------------------
#	����� ���������� ����������� �������             		
#	-------------------------------------------------------------------------------------------------------------------------------------
#	{$system/name/key/field}
	$sBlockData[^sBlockData.match[\{\^$system/([^^/]+)/([^^/]+)/([^^\}]+)\}][gi]{^getSystemObject[$match.1;$match.2;$match.3]}]
#	<system:value name="" key="" field=""/>
	$sBlockData[^sBlockData.match[<system:value name="([^^"]+)" key="([^^"]+)" field="([^^"]+)"/>][gi]{^getSystemObject[$match.1;$match.2;$match.3]}]
#	-------------------------------------------------------------------------------------------------------------------------------------

#	-------------------------------------------------------------------------------------------------------------------------------------
#	����� ���������� ����������� ������              <system:method name="">param</system:method>		
#	-------------------------------------------------------------------------------------------------------------------------------------
	$sBlockData[^sBlockData.match[<system:method name="([^^"]+)">([^^<]*)</system:method>][gi]{^getSystemMethod[$match.1;$match.2]}]
#	-------------------------------------------------------------------------------------------------------------------------------------

#	<mouse name="rules"></mouse>
}
$result[$sBlockData]
#end @parseBlockPostProcess[]

##################################################################################################
##                                                                                              ##
##                  ����������� ������                                                          ##
##                                                                                              ##
##################################################################################################
# ------------------------------------------------------------------------------------------------
#                   �������
# ------------------------------------------------------------------------------------------------
# ��������� ����������
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
# ����������� ������� �������
@getSystemMethod[sName;sParams][_jMethod;_hParams]
$result[
	$_jMethod[$$sName] 
	^_jMethod[^getSystemParams[$sParams]]
]
#end @getSystemParser[sName;sParams]

#################################################################################################
# ����������� ������� ��������
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
#                   �������� ����������� ������
# ------------------------------------------------------------------------------------------------
#################################################################################################
# ����� ������ ��������
@tree[hParam]
$result[^ObjectByParent[$[$hParam.hash_name];$hParam.thread_id;$.description[1]]]
#end @Tree[hParam]

#################################################################################################
# ����� ����� ��������
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
# ��������� � �������� ������
@sql[hParam][_jMethod]
^try{
# 	�������� ����� ��� �������� �������
	$_jMethod[$[${hParam.method}]]
# 	������� ������
	$[${hParam.name}][^_jMethod[$.where[${hParam.where}]]]
}{$exception.handled(1)}
$result[]
#end @sql[hParam]

#################################################################################################
# ��������� �������
@if[hParam][_jMethod]
$result[^if(${hParam.name} eq ${hParam.value}){${hParam.true}}{${hParam.false}}]
#end @sql[hParam]

#################################################################################################
# ����� ������ ������������� �����������
@executeSystemProcess[hParam][_jMethod]
$result[^executeBlock[$hParam.id;$hParam.body;$hParam.param;$hParam.field]]
#end @process[hParam][_jMethod]

##################################################################################################
##                                                                                              ##
##                  ������ � �������������                                                      ##
##                                                                                              ##
##################################################################################################

#################################################################################################
# ����� ������������ ��������
# � ��������, ��-�� ����� ��� executeBlock, �� ����������� ������� ����� �������� �� �������� ��� ������ ���������� :) 
@executeProcess[dataProcessID]
# ���������� ����������� � �������������
^prepareProcesess[$dataProcessID]
# ������ �����������
^if($PROCESSES_HASH.[$dataProcessID].main is junction){
# ������ �����������
	$result[^PROCESSES_HASH.[$dataProcessID].main[]]
}{
#	����� ������ ������ � �����������
	$result[]
}
#end @executeProcess[]

#################################################################################################
# ������ ������������ ������
@executeBlock[dataProcessID;blockParam;blockBody;blockFields]
# ���������� ����������� � �������������
^prepareProcesess[$dataProcessID]
# ������ �����������
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
# ������ + �������� + ��������� + ��������� ��� �����������
@prepareProcesess[dataProcessID][dataProcessMain;dataProcessFileName;dataProcessFile;dataProcessBody]
# ���������� ����� ���� ��� �� ��������
^if(!$PROCESSES_HASH.[$dataProcessID].processBodyLoaded){
#	������ ����� @main[...] �����������
	$dataProcessMain[process_${dataProcessID}_main]
	^try{
#		������ ���� �� �����������
		$dataProcessFileName[${MAIN:ProcessDir}$PROCESSES_HASH.[$dataProcessID].filename]
		$dataProcessFile[^file::load[text;$dataProcessFileName]]
#		���� �����������
		$dataProcessBody[^taint[as-is][$dataProcessFile.text]]
	
#		���������� ����������� � ������� (����� engine) ���������

		^process{@${dataProcessMain}^[lparams]
			$dataProcessBody}[
			$.main[$dataProcessMain]
			$.file[$dataProcessFileName]
		]
					
#		���������� ���������� � ��� � main dataProcess
		$PROCESSES_HASH.[$dataProcessID].main[$$dataProcessMain]
	}{
#		���-�� ��������� ��� ������ � ����������
#		��� ������������� � debug ����� ����������������
		$exception.handled(1)
	}
#	� ����� ������ ���������, ��� ���� ������������
#	������� �� �������� � ��������� ���������� �����������
	$PROCESSES_HASH.[$dataProcessID].processBodyLoaded(1)
}


##################################################################################################
##                                                                                              ##
##                  ������                                                                      ##
##                                                                                              ##
##################################################################################################

#################################################################################################
# � ������ ����� ������� ���� �� ���������
@ObjectByParent[lparams;parent_id;params][tblLvlObj;_hParams]
$_hParams[^hash::create[$params]]
^if($_hParams.level){^_hParams.level.inc(1)}{$_hParams.level(1)}
# ���� �� ���� � ��������?
^if($lparams.[$parent_id]){
# �������� ������� ����� ��������
  $tblLvlObj[$lparams.[$parent_id]]
#   � ������� ��� � ��� � ������� �������
    ^tblLvlObj.menu{
		^printItem[$tblLvlObj.fields;^if($lparams.[$tblLvlObj.id]){^ObjectByParent[$lparams;$tblLvlObj.id;$_hParams]};$_hParams]
    }
    ^_hParams.level.dec(1)
}


#################################################################################################
# ����� ����� ������ xml
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
# �������� ������ ���� ������������ � ��������� �����
@DeleteFiles[sDir;sName]
^try{
#	�������� � �������� ������� ����
	$_tList[^file:list[$sDir;${sName}_*[^^\.]*\.cache^$]] 
	^_tList.menu{^file:delete[${sDir}$_tList.name]} 
}{
#	���� ��� �� �� ���.. � �� � ��� � ���!
	$exception.handled(1)
}
#end @DeleteFiles[sDir;sName]

#################################################################################################
# �������������� ����� ���� � ���� ����
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
# �������������� ���� ���� � ����� ����
@getIntRights[hRights]
$result($hRights.read + $hRights.edit + $hRights.delete + $hRights.comment + $hRights.supervisory)
#end @getIntRights[hRights]

#################################################################################################
# ��������� ������� ���� �������
@getFullPath[_iParentId;_sPath]
$result[^if(^_iParentId.int(0)){$OBJECTS_HASH.[$_iParentId].full_path}{/}$_sPath/]
#end @getFullPath[_iParentId;_sPath]

#################################################################################################
# ��������� ����� �������
@getThreadId[_iParentId;_iId]
$result[^if(^_iParentId.int(0)){$OBJECTS_HASH.[$_iParentId].thread_id}{^OBJECTS_HASH.[$_iId].id.int(0)}]
#end @getThreadId[_iParentId]

#################################################################################################
# ����� HTML entities - ���� �.�. � XML ����� ����������� ��� ������
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
##                  SQL �������
##
##################################################################################################
# ����� ����������� � ����������� sql ������
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
# �������� �� sql ������� � �������������������� �������
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
# �������� ������� 
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
# �������� �� sql ��� ������������������ �������
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
# ����� ������� ��� ����� ������� 
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
# �������� �� sql ��� ������������������ �����������
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
# ������� ������� �� ������� ��� ������ :)                                                      #
# ������ ����� ����, � �� ����, ������ �������������� ��������� �����, ��� - � ������!          #
#################################################################################################