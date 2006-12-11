#################################################################################################
# $Id: debug.p,v 1.1 2006/02/09 17:12:53 Sanja Exp $
#################################################################################################
@CLASS
debug



###################################################################################################
# вывод объекта
@show[oName;sFile][sOut;dNow]
$sOut[^taint[optimized-as-is][
		^if(!def $oName){
			^if($oName is "bool"){
				^debugShowBool[$object]
			}{
				^debugShowVoid[$object]
			}
		}{
			^if($oName is "date"){^debugShowDate[$oName]}
			^if($oName is "file"){^debugShowFile[$oName]}
			^if($oName is "image"){^debugShowImage[$oName]}
			^if($oName is "bool"){^debugShowBool[$oName]}
			^if($oName is "table"){^debugShowTable[$oName]}
			^if($oName is "string"){^debugShowString[$oName]}
			^if($oName is "int" || $oName is "double"){^debugShowDouble[$oName]}
			^if($oName is "hash"){^debugShowHash[$oName]}
		}
]]
^if(def $sFile){
	$dNow[^date::now[]]
$sOut[<br />Begin (^dNow.sql-string[]${sOut}End<br />]
	^sOut.save[append;$sFile]
}{
	$result[$sOut]
}
#end @show[oName;sFile][sOut;dNow]



###################################################################################################
@debugShowString[text;shash]
$result[<strong>^text.replace[^table::create[nameless]{^taint[^#0A	<br>]}]</strong>^if(!def $shash){ (string)}]
#end @debugShowString[]




@debugShowDouble[d;shash]
###################################################################################################
$result[<strong>$d</strong>^if(!def $shash){( (int/double))}]
#end @debugShowDouble[]




@debugShowBool[b;shash]
###################################################################################################
$result[<strong>^if($b){true}{false}</strong>^if(!def $shash){ (bool)}]
#end @debugShowBool[]




@debugShowVoid[v;shash]
###################################################################################################
$result[^if(!def $shash){<strong>Значение не присвоено</strong> (void)}]
#end @debugShowVoid[]




@debugShowFile[f][_f]
###################################################################################################
^try{
	$_f[^file::stat[$f.name]]
	$result[Файл <strong>^file:fullpath[$f.name]</strong><br />
	Размер: <strong>$_f.size байт</strong><br />
	Создан: <strong>${_f.cdate.day}.${_f.cdate.month}.${_f.cdate.year} в 
	${_f.cdate.hour}ч.${_f.cdate.minute}мин</strong><br />
	Изменен: <strong>${_f.mdate.day}.${_f.mdate.month}.${_f.mdate.year} в 
	${_f.mdate.hour}ч.${_f.mdate.minute}мин</strong><br />
	Последний раз обращение к файлу производилось <strong>${_f.adate.day}.${_f.adate.month}.${_f.adate.year} в 
	${_f.adate.hour}ч.${_f.adate.minute}мин.</strong><br />
	MIME-тип файла: <strong>$_f.content-type</strong><br />
	^if(${_f.content-type} eq "text/plain" || ${_f.content-type} eq "text/html"){
	Первые 100 символов файла:<br />
	<strong><i>^f.text.left(100)...</i></strong><br />
	Последние 100 символов файла:<br />
	<strong><i>...^f.text.right(100)</i></strong><br />
	}
	]
}{
	$exception.handled(1)
	$result[<font color="red"><strong>^file:fullpath[$f.name]</strong> (file) не найден!</font>]
}
#end @debugShowFile[]




@debugShowDate[d]
###################################################################################################
$result[<strong>${d.day}.${d.month}.${d.year}, ${d.hour}час ${d.minute}мин ${d.second}сек. $d.yearday день года</strong>]
#end @debugShowDate[]




@debugShowImage[i]
###################################################################################################
$result[^if(def $i.src){<strong>^i.html[]</strong>}{<strong>Графический объект созданный Parser3.</strong>}<br />
Высота изображения^: ${i.height}px, ширина^: ${i.width}px<br />
^if(def $i.exif){^debugShowHash[$i.exif]}{EXIF информация в файле отсутствует!<br />}]
#end @debugShowImage[]




@debugShowTable[t][_tcol;_t;_path]
###################################################################################################
^if(^t.columns[] != ^t.flip[]){
	$_path[/^math:uid64[]]
	^t.save[$_path]
	$_t[^table::load[$_path]]
	^file:delete[$_path]
	Объект является <strong>nameless</strong> таблицей!<br />
	^debugShowTable[$_t]
}{
	$_tcol[^t.columns[]]
	$result[<table cellSpacing="1" cellPadding="1" border="1">
	<tr align="center">
	^_tcol.menu{
		<td><strong>$_tcol.column</strong></td>
	}
	</tr>

	^t.menu{
	<tr align="center">
		^_tcol.menu{
		<td>$t.[$_tcol.column]</td>
		}
	</tr>
	}
	</table>]
}
#end @debugShowTable[]




@debugShowHash[h][k;v;_sdiv]
###################################################################################################
^if(!def $caller.$_sdiv){$_sdiv(0)}

^_sdiv.inc(50)

^h.foreach[k;v]{<div style="padding-left: ${_sdiv}px">
	^if(!def $v){
		^if($v is "bool"){
			^$.$k^[^debugShowBool[$v;1]^]<br />
		}{
			^$.$k^[^debugShowVoid[$v;1]^]<br />
		}
	}{
		^if($v is "bool"){^$.$k^[^debugShowBool[$v;1]^]}
		^if($v is "string"){^$.$k^[^debugShowString[$v;1]^]}
		^if($v is "date"){^$.$k^[^debugShowDate[$v]^]}
		^if($v is "image"){^$.$k^[<div style="padding-left: 50px">^debugShowImage[$v]</div>^]}
		^if($v is "file"){^$.$k^[<div style="padding-left: 50px">^debugShowFile[$v]</div>^]}
		^if($v is "table"){^$.$k^[<div style="padding-left: 50px">^debugShowTable[$v]</div>^]}
		^if($v is "int" || $v is "double"){^$.$k^(^debugShowDouble($v;1)^)}
		^if($v is "hash"){
			^_sdiv.inc(50)
			^$.$k^[^debugShowHash[$v]^]
			^_sdiv.dec(50)
		}
	}
</div>}
#end @debugShowHash[]
