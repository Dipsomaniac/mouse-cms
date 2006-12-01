###########################################################################
# $Id: lib.p,v 1.57 2006/04/21 14:07:17 misha Exp $
###########################################################################

##  @color[sColor1;sColor2]			������ ������ color
##  @include[sFile]					������ ������ include
##  @trim[string;char]				�������� ������� � � ����� ������ ��� ������� char (�� ��������� ��� ���������� �������)
##  @image[sFile;sAttr]				���������� <img src="$sFile" width="..." height="..." $sAttr /> ���� ���� ����������
##  @image_size[sFile]				���������� ������ width="" height="" � ��������� ��� ������� ��������
##  @file_copy[sFileFrom;sFileTo]		����������� �����
##  @file_size[sFile;hName;sDivider]		���������� ������ � �������� �����. ����� ������ ����� �������� ��������� � �����������
##  @dir_copy[sDirFrom;sDirTo;params]		����������� ����������
##  @href[sUrl;sLabel;sAttr]			���� ����� $sUrl - �� ������ ������ � ����������� $sAttr, ����� ���������� $sLabel
##  @location[sUrl;hParam]			������������� ����, ��� �� ����� ������ ������ � ��� � �������������� �� $sUrl
##  @is_email[sEmail]				���������, ��������-�� ��������� ������ �������� ������� ����������� �����
##  @createTreeHash[table;key]			������� �� ������� ��� ������, ��� ���� - $key (default eq "parent_id"), � �������� - �������
##  @node2str[nNode;sRootTag]			��������� ������ ^nNode.string[] ��� $nNode
##  @doc2str[xDoc]				�� xDoc ������ � ���������� ������ ��������� ���������� xml � DOCTYPE
##  @dec2bin[iNum]				����������� ������������ ����� � ������, �������������� ��� � �������� ����
##  @number_format[number;spacer;decimal_divider_in;frac_length]	��������� ����� �� ������, � ������� ��� 
##									� �������������� ���� � ������� ������������ ������������ � ������������� �����
##  @foreach[hash;key;value;code;separator;direction]	����������� ������� .foreach ��� �������� ��������� ����
##  @run_time[code;var_name]		��������� ��������� ��� ���, ������� �����, ������� ������ ��� �����������
##  @setExpireHeaders[date]			����� ������������� ��������� Last-Modified (���� ������ ����) ��� Expires

##  @getIconPathByExt[sFileExt;sIconSuffix]
##  @getIconByExt[sFileExt;sIconSuffix;sImageAttr]
##  @getIconByFile[sFileName;sIconSuffix;sImageAttr]
##
##  ����������� ������ ���� ���� � ��������� ��� 6 �������, � ��� ����� �������!



###########################################################################
# ������ ������ color: ������ ������ ����� ���������� $color1, ������ �������� - $color2
# ����� ��� ���������� - ����� ������������������
@color[sColor1;sColor2]
^if(!def $iColorSwitcher || (!def $sColor1 && !def $sColor2)){$iColorSwitcher(0)}
$iColorSwitcher($iColorSwitcher !| 1)
$result[^if($iColorSwitcher & 1){$sColor2}{$sColor1}]
#end @color[]



###########################################################################
# load and process file
@include[sFile][fFile]
^if(def $sFile && -f $sFile){
	$fFile[^file::load[text;$sFile]]
	^if(def $caller.self){
		$result[^process[$caller.self]{^taint[as-is][$fFile.text]}]
	}{
#		for backward compatibility
		$result[^process{^taint[as-is][$fFile.text]}]
	}
}{
	$result[]
}
#end @include[]



###########################################################################
# �������� ��������� � �������� ������� $char � ������ $str. 
# ���� $char �� ����� - �� �������� ��������� � �������� ���������� �������
# ��� ������� >= 3.1.2 ����� ������������ ^������.trim[]
@trim[str;char][chr;tbl]
^if(def $str){
	$chr[^if(def $char){$char}{\s}]
	$str[^str.match[^^$chr*][]{}]
	$tbl[^str.match[^^(.*[^^$chr])$chr*^$]]
	$result[$tbl.1]
}{
	$result[]
}
#end @trim[]



###########################################################################
# ���������� ������ width="" height="" � ��������� ��� ������� ��������
@image_size[sFile][fImage]
^if(def $sFile && -f $sFile){
	$fImage[^image::measure[$sFile]]
	$result[ width="$fImage.width" height="$fImage.height" ]
}{
	$result[]
}
#end @image_size[]



###########################################################################
# ���������� <img src="sFile" width="..." height="..." $sAttr /> ���� $sFile ����������
@image[sFile;sAttr][fImage]
^if(def $sFile && -f $sFile){
	$fImage[^image::measure[$sFile]]
	$result[<img src="$fImage.src" width="$fImage.width" height="$fImage.height"^if(def $sAttr){ $sAttr} />]
}{
	$result[]
}
#end @image[]



###########################################################################
# ���������� ������ � �������� �����. ����� �������������� ��������� ����/��/�� � ������ �����������
@file_size[sFile;hName;sDivider][fFile]
^if(def $sFile && -f $sFile){
	^if(!$hName){$hName[$.b[����]$.kb[��]$.mb[��]]}
	$fFile[^file::stat[$sFile]]
	^if($fFile.size < 1000){
		$result[$fFile.size $hName.b]
	}{
		^if($fFile.size < 1000000){
			$result[^eval($fFile.size/1024)[%.1f] $hName.kb]
		}{
			$result[^eval($fFile.size/1048576)[%.1f] $hName.mb]
		}
	}
	$result[^result.match[\.0(\s)][]{$match.1}]
	^if(def $sDivider){
		$result[^result.match[\.][]{$sDivider}]
	}
}{
	$result[]
}
#end @file_size[]



###########################################################################
# coping file $from_file to $to_file
@file_copy[sFileFrom;sFileTo][fFile]
^if(def $sFileFrom && -f $sFileFrom && def $sFileTo && $sFileFrom ne $sFileTo){
	$fFile[^file::load[binary;$sFileFrom]]
	^fFile.save[binary;$sFileTo]
}
#end @file_copy[]



###########################################################################
# copy directory $sDirFrom to $sDirTo
# with $.is_recursive(1) - will copy all subdirectories
@dir_copy[sDirFrom;sDirTo;hParam][tFileList]
^if(def $sDirFrom && -d $sDirFrom && def $sDirTo && $sDirFrom ne $sDirTo){
	$tFileList[^file:list[$sDirFrom]]
	^tFileList.menu{
		^if($hParam.is_recursive && -d "$sDirFrom/$tFileList.name"){
			^dir_copy[$sDirFrom/$tFileList.name;$sDirTo/$tFileList.name;$hParam]
		}
		^if(-f "$sDirFrom/$tFileList.name"){
			^file_copy[$sDirFrom/$tFileList.name;$sDirTo/$tFileList.name]
		}
	}
}
#end @dir_copy[]



###########################################################################
# ���� ����� $sUrl - �� ������ ������ � ����������� $sAttr, ����� ���������� $sLabel
@href[sUrl;sLabel;sAttr]
^if(!def $sLabel){$sLabel[$sUrl]}
^if(def $sUrl){
	$result[<a href="$sUrl"^if(def $sAttr){ $sAttr}>$sLabel</a>]
}{
	$result[$sLabel]
}
#end @href[]



###########################################################################
# make $response:location to $sUrl, and set flag for cache skipping
@location[sUrl;hParam]
$result[]
^if(def $sUrl){
#	for manual skipping cache
	$MAIN:wrongCache(1)
#	can called outside of cache operator
	^try{
		^cache(0)
	}{
		$exception.handled(1)
	}
	^if($hParam.is_external){
		$response:location[http://${env:SERVER_NAME}^sUrl.match[^^[a-z]+://[^^/]+][i]{}]
	}{
		$response:location[$sUrl]
	}
}
#end @location[]



###########################################################################
# check email format
@is_email[sEmail]
$result(^if(def $sEmail && ^sEmail.pos[@] > 0 && ^sEmail.match[^^\w+([.-]?\w+)+\@\w+([.-]?\w+)*\.[a-z]{2,4}^$][i]){1}{0})
#end @is_email[]



###########################################################################
# print $nNode as string (something like ^xdoc.string[])
@node2str[nNode;sRootTag][xDoc;nCurrent;_tmp]
$xDoc[^xdoc::create{<?xml version="1.0" encoding="$request:charset" ?><^if(def $sRootTag){$sRootTag}{dummy-parent-tag} />}}]
$nCurrent[$nNode.firstChild]
^while($nCurrent){
	$_tmp[^xDoc.documentElement.appendChild[^xDoc.importNode[$nCurrent](1)]]
	$nCurrent[$nCurrent.nextSibling]
}
$result[^doc2str[$xDoc]]
^if(!def $sRootTag){
	$result[^result.match[</?dummy-parent-tag.*?>][g]{}]
}
#end @node2str[]



###########################################################################
# print $xDoc as string removing xml declaration
@doc2str[xDoc]
$result[^trim[^xDoc.string[
    $.omit-xml-declaration[yes]
]]]
$result[^result.match[<!DOCTYPE[^^>]+>][i]{}]
#end @doc2str[]



###########################################################################
# print number as a decimal string
@dec2bin[iNum][i]
$i(1 << 23)
$result[^while($i>=1){^if($iNum & $i){1}{0}$i($i >> 1)}]
#end @dec2bin[]



###########################################################################
# ������� �� ������� ��� ������, ��� ���� - $key, � �������� - �������
@createTreeHash[table;key][k;empty_table]
^if($table is "table"){
	$k[^if(def $key){$key}{parent_id}]
	^try{
		$result[^table.hash[$k][$.distinct[tables]]]
	}{
#		for old parser versions do it ourself
		$exception.handled(1)
		$result[^hash::create[]]
		$empty_table[^table::create[$table][$.limit(0)]]
		^table.menu{
			^if(!$result.[$table.[$k]]){$result.[$table.[$k]][^table::create[$empty_table]]}
			^result.[$table.[$k]].join[$table][$.offset[cur]$.limit(1)]
		}
	}
}
#end @createTreeHash[]



###########################################################################
# ��������� ����� �� ������, � ������� ��� � �������������� ���� � ������� 
# ������������ ������������ � ������������� �����
@number_format[number;spacer;decimal_divider_in;frac_length][num;numberSign;numberParts;numberLeftPart;right_part;numberOut;leftn;fl]
$numberParts[^number.lsplit[.]]

$numberSign(^math:sign($number))
$numberLeftPart[^eval(^math:abs($numberParts.piece))[%.0f]]

^if(^numberParts.count[] > 1){
	^numberParts.offset(1)
	$right_part[$numberParts.piece]
}

^if(^numberLeftPart.length[] > 4){
	$left_length_mod(^numberLeftPart.length[] % 3)
	^if($left_length_mod){
		$leftn[^numberLeftPart.match[(\d{$left_length_mod})(\d*)]]
		$numberOut[$leftn.1]
		$numberLeftPart[$leftn.2]
	}{
		$numberOut[]
	}
	$num(0)
	$numberOut[${numberOut}^numberLeftPart.match[(\d{3})][g]{^if($num || def $numberOut){^if(def $spacer){$spacer}{&nbsp^;}}^num.inc(1)$match.1}]
}{
	$numberOut[$numberLeftPart]
}

$result[^if($numberSign < 0){-}${numberOut}^if(^numberParts.count[] > 1){^if(def $decimal_divider_in){$decimal_divider_in}{,}^if(!def $frac_length){$right_part}{$fl[^frac_length.int(0)]$rl(^right_part.length[])^if($rl < $fl){^right_part.left($fl)$zero[0]^zero.format[%0^eval($fl-$rl)d]}{^right_part.left($fl)}}}{^if(def $frac_length){^if(def $decimal_divider_in){$decimal_divider_in}{,}$zero[0]^zero.format[%0^eval(^frac_length.int(0))d]}}]
#end @number_format[]



###########################################################################
# �������� ���������� �������� ���� � �������� �������
@foreach[hash;key;value;code;separator;direction][_keys;_int]
^if($hash is "hash"){
	$direction[^if(def $direction){$direction}{asc}]
	$_keys[^hash._keys[]]
	$_int(0)
	^_keys.menu{^if(^_keys.key.int(0)){$_int(1)}}
	^if($_int){
		^_keys.sort($_keys.key)[$direction]
	}{
		^_keys.sort{$_keys.key}[$direction]
	}
	^_keys.menu{
		$caller.[$key][$_keys.key]
		$caller.[$value][$hash.[$_keys.key]]
		$code
	}[$separator]
}{
	^throw[parser.runtime;foreach;Variable must be hash]
}
#end @foreach[]


###########################################################################
# ��������� ��������� ��� ���, ������� �����, ������� ������ ��� ����������� � ����������� ������.
# ���������� ���������� ������������ � ����������, ��� ������� �� �������� ������ ����������.
# ���� ������ �� �������� ������ ���������� - �� ������ �� ��������, ��������������.
# �� ������ �����:
#	.time - ������� ����� ���������� ���� (� ������������)
#	.utime - ������ ����� ������ ���� (� ��������)
#	.memory_kb - �������������� ������ (� KB)
#	.memory_block - ������������ ������ (� ������)
@run_time[code;var_name][begin;end]
^if(def $var_name){
	^try{
		$begin[
			$.rusage[$status:rusage]
			$.memory[$status:memory]
		]
	}{
		$exception.handled(1)
	}
	$result[$code]
	^try{
		$end[
			$.rusage[$status:rusage]
			$.memory[$status:memory]
		]
	}{
		$exception.handled(1)
	}
	$caller.[$var_name][
		$.time((^end.rusage.tv_sec.double[] - ^begin.rusage.tv_sec.double[])*1000 + (^end.rusage.tv_usec.double[] - ^begin.rusage.tv_usec.double[])/1000)
		$.utime($end.rusage.utime - $begin.rusage.utime)
		$.memory_block($end.rusage.maxrss - $begin.rusage.maxrss)
		^if($begin.memory){
#			$.memory_kb($begin.memory.free - $end.memory.free)
			$.memory_kb($end.memory.used - $begin.memory.used)
		}
	]
}{
	$result[$code]
}
#end @run_time[]



###########################################################################
# ����� ������������� ��������� Last-Modified/Expires
# ���� ������ $date �� ������������� � � Last-Modified, ���� �� ������, ������ Expires
@setExpireHeaders[date][_d]
^if(def $date){
	^if($date is "string"){
		$_d[^date::create[$date]]
	}
	^if($date is "date"){
		$_d[^date::create($date)]
	}
}
^if($_d && $_d < ^date::now(-7)){
	$response:Last-Modified[$_d]
}{
	$response:expires[Fri, 23 Mar 2001 09:32:23 GMT]
	$response:cache-control[no-store, no-cache, must-revalidate, proxy-revalidate]
	$response:pragma[no-cache]
}
#end @setExpireHeaders[]



###########################################################################
@getIconPathByExt[sFileExt;sIconSuffix][sIconDir;sFile;sFileDef]
$sIconDir[/i/icons]
$sFile[$sIconDir/${sFileExt}${sIconSuffix}.gif]
$sFile[^sFile.lower[]]
$result[^if(def $sFile && -f $sFile){$sFile}{$sFileDef[$sIconDir/none${sIconSuffix}.gif]^sFileDef.lower[]}]
#end @getIconPathByExt[]



###########################################################################
@getIconByExt[sFileExt;sIconSuffix;sImageAttr]
$result[^image[^getIconPathByExt[$sFileExt;$sIconSuffix];border="0"^if(def $sImageAttr){ $sImageAttr}]]
#end @getIconByExt[]



###########################################################################
@getIconByFile[sFileName;sIconSuffix;sImageAttr]
$result[^getIconByExt[^file:justext[$sFileName];$sIconSuffix;$sImageAttr]]
#end @getIconByFile[]



###########################################################################
###########################################################################
# ������ ���������� ��� �������� ������������� [����]. ����� �� �� ������������


###########################################################################
@default[var;dflt][v]
# ������ ������ default: ���� ���������� $var ������������ ���, ����� - $dflt
# ����������� ���������� ������: ^default[$val]{$dflt}
$v[$var]
$result[^if(def $v){$v}{$dflt}]
#end @default[]



###########################################################################
@ifdef[var;def;undef][v]
# ������ ������ ifdef: ���� ���������� $var ������������ $def, ����� - $undef
# ����������� ���������� ������: ^ifdef[$var]{$def}{$undef}
$v[$var]
$result[^if(def $v){$def}{$undef}]
#end @ifdef[]



###########################################################################
@is_flag[data]
# ���� ���������� �������� ����� 0 ��� �� ����� - ���������� 0, ����� 1
$result(^if(^data.int(0)){1}{0})
#end @is_flag[]



###########################################################################
@max[inhash][tmp;max;key;value]
# return maximum hash value
$tmp[^inhash._keys[]]
$max[$tmp.key]
^inhash.foreach[key;value]{^if($value > $max){$max[$value]}}
$result[$max]
#end @max[]



###########################################################################
@load[param1;param2][named;file]
# �������� ������ �� ����� � ������� (������ ������ load). 
# �������� �����, �.�. �������� ^table::load[���_�����] ������ �� �������
^if(def $param2){$file[$param2]$named[$param1]}{$file[$param1]$named[]}
$f[^file:find[$file]]
^if(def $f){
	^if(def $named){
		$result[^table::load[$f]]
	}{
		$result[^table::load[nameless;$f]]
	}
}{
	$result[^table::create[nameless]{}]
}
#end @load[]



###########################################################################
@remove[in;pos;cnt;where][first;last]
# ������� $cnt ����� �� ������� $in ������� � $pos
# ��� ���� ���������� $where (��� ����� ���� �������, ����: ^remove[$tbl;2;1]{^if($tbl.a eq a4){1}{0}} )
# � ����� ����� ������ �������� ������ ^�������.select{�������}
^if(def $in){
	$first(^pos.int(0))
	$last($first+^cnt.int(1))
	$result[^in.select(((^in.line[]<$first) || (^in.line[]>=$last+$count)) && !$where)]
}{
	$result[$in]
}
#end @remove[]



###########################################################################
@getFileExt[sFile]
# ���������� ���������� �� ���������� ����� �����.
# ����� ��� ������, �.�. �� ���� ^file:justext[]
$result[^file:justext[$sFile]]
#end @getFileExt[]



###########################################################################
@imageSize[sFile]
# ��� �������� �������������
$result[^image_size[$sFile]]
#end @imageSize[]



###########################################################################
@fileSize[file;names;divider]
# ��� �������� �������������
$result[^file_size[$file;$names;$divider]]
#end @fileSize[]



###########################################################################
@macro_use[sFile]
# ������ ������ macro_use, �������� ������ ��� $CLASS_PATH ������� � ���� ������, � �� �������.
^if($MAIN:CLASS_PATH is "string" && def $sFile){
	$result[^include[$MAIN:CLASS_PATH/$sFile]]
}{
	$result[]
}
#end @macro_use[]



###########################################################################
@nodeToStr[node;tag]
# ���� �������� ��� �������� �������������
$result[^node2str[$node;$tag]]
#end @nodeToStr[]



###########################################################################
@getStrToHash[sString]
^process{^$_hTemp[^^hash::create[$sString]]}
$result[$_hTemp]
$_hTemp[]
#end @getStrToHash[sString]

###########################################################################
# delete directory $sDir
# with $.is_recursive(1) - will delete all subdirectories
@dir_delete[sDir;hParam][tFileList]
^try{
	$tFileList[^file:list[$sDir]]
	^tFileList.menu{
		^if($hParam.is_recursive && -d "$sDir/$tFileList.name"){
			^dir_delete[$sDir/$tFileList.name;$hParam]
		}
		^if(-f "$sDir/$tFileList.name"){
			^file:delete[$sDir/$tFileList.name]
		}
	}
}{
	$exception.handled(1)
}
#end @dir_delete[]
