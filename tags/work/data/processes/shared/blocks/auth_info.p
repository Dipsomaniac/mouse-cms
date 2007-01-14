$lparams.body
<block_content>
^if($MAIN:objAuth.is_logon){
	<li><b>Login: </b>$MAIN:objAuth.user.name</li>
	<li><b>E-mail: </b>$MAIN:objAuth.user.email</li>
	<li><b>Rights: </b> 
	<ul>
		^hRights.foreach[sName;sValue]{
			^if($sValue){<li>$sName</li>}
		}
		</ul>
	</li>
	<li><a href="/reg/">Параметры</a></li>
	^MAIN:objAuth.xmlFormLogout[$.target_url[./]]
}{
	^MAIN:objAuth.xmlFormLogon[
		$.target_url[./]
		$.addon[
			<a href="$crdObject.hash.4.full_path" title="Регистрация">Регистрация</a>
		]
	]
}
</block_content>