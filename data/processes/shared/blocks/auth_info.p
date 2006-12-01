$lparams.body
<block_content>
^if($MAIN:objAuth.is_logon){
<ul>
	<li><b>Login: </b>$MAIN:objAuth.user.name</li>
	<li><b>E-mail: </b>$MAIN:objAuth.user.email</li>
	<li><b>Rights: </b> $RIGHTS <ul>
		^HASH_RIGHTS.foreach[name;value]{
			^if($value){<li>$name</li>}
		}
		</ul>
	</li>
</ul>
	^MAIN:objAuth.xmlFormLogout[$.target_url[./]]
}{
	^MAIN:objAuth.xmlFormLogon[$.target_url[./]]
}
</block_content>