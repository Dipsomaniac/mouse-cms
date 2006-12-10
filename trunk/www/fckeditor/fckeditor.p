@CLASS
fckeditor



#################################################################################################
# инициализация
@init[sName]
$sInstanceName[$sName]
$sPath[/fckeditor/]
$sWidth[100%]
$sHeight[200]
$sToolbarSet[Default]
$sValue[]
$hConfig[^hash::create[]]
#end @init[sInstanceName]



#################################################################################################
# Вывод HTML
@create[][sFile;sLink]
<div>
^if(^isCompatible[]){
	^if((def $form:fcksource) && ($form:fcksource eq 'true')){$sFile[fckeditor.original.html]}{$sFile[fckeditor.html]}
	$sLink[${sPath}editor/${sFile}?InstanceName=${sInstanceName}&amp^;Toolbar=${sToolbarSet}]
	<input type="hidden" id="$sInstanceName" name="$sInstanceName" value="$sValue" style="display:none" />
	<input type="hidden" id="${sInstanceName}___Config" name="fckdelete" value="^getConfigFieldString[]" style="display:none" />
	<iframe id="${sInstanceName}___Frame" src="$sLink" width="$sWidth" height="$sHeight" frameborder="0" scrolling="no"></iframe>
}{
	^if(^Width.pos[%] < 0){$sWidth[${sWidth}px]}
	^if(^Height.pos[%] < 0){$sHeight[${sHeight}px]}
	<textarea name="$sInstanceName" rows="4" cols="40" style="width: $sWidth^; height: $sHeight">$sValue</textarea>
}
</div>
#end @CreateHtml[][HtmlValue;Link;File;WidthCSS;HeightCSS]



#################################################################################################
# Проверка совместимости
@isCompatible[sAgent]
$sAgent[$env:HTTP_USER_AGENT]
^if(^sAgent.pos[mac] < 0 && ^sAgent.pos[Opera] < 0){$result(1)}{$result(0)}
# пока отключил fckeditor ибо сбоит
$result(0)
#end @IsCompatible[sAgent] >



#################################################################################################
# Строка конфига
@getConfigFieldString[][bFirst]
$result[]
^hConfig.foreach[sKey;sValue]{
	^if(^bFirst.int(0)){$result[${result}&amp^;]}{$bFirst(1)}
	$result[${result}${sKey}='${sValue}']}
#end @GetConfigFieldString[][bFirst]
