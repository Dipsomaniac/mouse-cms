@CLASS
fckeditor

@Init[instanceName]
$InstanceName[$instanceName]
$BasePath[/fckeditor/]
$Width[100%]
$Height[200]
$ToolbarSet[Default]
$Value[]
$Config[^hash::create[]]

@Create[]
^CreateHtml[]

@CreateHtml[][HtmlValue;Link;File;WidthCSS;HeightCSS]
$HtmlValue[$Value]
<div>
^if(^IsCompatible[]){
	^if((def $form:fcksource) && ($form:fcksource eq 'true')){$File[fckeditor.original.html]}{$File[fckeditor.html]}
	$Link[${BasePath}editor/${File}?InstanceName=${InstanceName}^if(def $ToolbarSet){&amp^;Toolbar=$ToolbarSet}^if($Config.mode eq 'noengine'){&amp^;mode=$Config.mode}]
	<input type="hidden" id="$InstanceName" name="$InstanceName" value='$HtmlValue' style="display:none" />
	<input type="hidden" id="${InstanceName}___Config" value="^GetConfigFieldString[]" style="display:none" />
	<iframe id="${InstanceName}___Frame" src="$Link" width="$Width" height="$Height" frameborder="no" scrolling="no"></iframe>
}{
	^if(^Width.pos[%] > -1){$WidthCSS[${Width}px]}{$WidthCSS[$Width]}
	^if(^Height.pos[%] > -1){$HeightCSS[${Height}px]}{$HeightCSS[$Height]}
	<textarea name="$InstanceName" rows="4" cols="40" style="width: $WidthCSS^; height: $HeightCSS">${HtmlValue}</textarea>
}
</div>

# В корневом main должно быть определено $MAIN:browser $MAIN:platform (в Mouse определяется)
@IsCompatible[]
^if(^MAIN:browser.pos[opera] > -1 ||  ^MAIN:platform.pos[mac] > -1 ){$result(0)}{$result(1)}

@GetConfigFieldString[]
$sParams[]
$bFirst(1)
$result[^Config.foreach[sKey;sValue]{^if(!$bFirst){$sParams[${sParams}&amp^;]}{$bFirst(0)}^try{^if($sValue == 1){$sParams[${sParams}${sKey}=true]}{$sParams[${sParams}${sKey}=false]}}{$exception.handled(1)$sParams[${sParams}${sKey}=${sValue}]}}]
