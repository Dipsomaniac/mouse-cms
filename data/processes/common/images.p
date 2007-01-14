#################################################################################################
# $Id: images.p,v 0.01 10:32 10.01.2007 KleN Exp $
#################################################################################################
@CLASS
images



#################################################################################################
@auto[]
^if(^env:PARSER_VERSION.pos[win32]){
	$nconvert_path[/nconvert/nconvert.exe]
	}{
	$nconvert_path[/nconvert/nconvert]
	}
#end @auto[]

#################################################################################################
# сохраняет файл изображения
# $.image		- file файл изображения
# $.path			- string путь сохранения
# $.name			- string имя сохранения
# $.format		- string формат файла
# $.meta			- bool удалить мета данные
@save[hParams][f;result]
^if($hParams.image && $hParams.image is "file"){
	^if($hParams.path is string){$hParams.path[^hParams.path.trim[end;/]]}
	^if(!def $hParams.name){$hParams.name[^file:justname[$hParams.image.name]]}
	^if(def $hParams.format){
		$hParams.name[${hParams.name}.${hParams.format}]
		^if($hParams.format eq jpg){$hParams.format[jpeg]}
		^hParams.image.save[binary;$hParams.path/$hParams.name]
		$f[^file::exec[$nconvert_path;;-D;-o;${env:DOCUMENT_ROOT}$hParams.path/$hParams.name;-q;80;^if($hParams.meta){-rmeta};-rexifthumb;-out;$hParams.format;${env:DOCUMENT_ROOT}$hParams.path/$hParams.name;]]
	}{
		$hParams.name[${hParams.name}.^file:justext[$hParams.image.name]]
		^hParams.image.save[binary;$hParams.path/$hParams.name]
	}
	$result[$.done[$f.stderr]$.path[$hParams.path]$.name[$hParams.name]]
}{
	$result[$.done[No file.]]
}
#end @save[hParams][f;result]


#################################################################################################
# изменение размеров
# $.name				- string имя сохранения с путем и расширением
# $.source_name	- string имя источника с путем и расширением
# $.quality			- int качество 0-100
# $.width			- int ширина можно указать в % (пр. 80%)
# $.height			- int высота
@resize[hParams][f;result]
$f[^file::exec[$nconvert_path;;-o;${env:DOCUMENT_ROOT}$hParams.name;-q;^if(^hParams.quality.int(0)){$hParams.quality}{80};^if(^hParams.width.int(0) && ^hParams.height.int(0)){-normalize}{-ratio};-resize;^if(^hParams.width.int(0)){$hParams.width};^if(^hParams.height.int(0)){$hParams.height};${env:DOCUMENT_ROOT}$hParams.source_name]]
$result[$f.stderr]
#end @resize[hParams][f;result]