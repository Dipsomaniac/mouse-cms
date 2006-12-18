^mRegisterRun[$lparams]



#################################################################################################
# Обработка пользователя
@mRegisterRun[hParams][hTemp]
<block_content>
^if(def $form:register){
	^if($MAIN:objAuth.is_logon){
		^try{
			^rem{ *** сохраняем параметры существующего пользователя *** }
			^MAIN:objAuth.updateUser[$form:fields]
			<p>Параметры пользователя сохранены.</p>
		}{
			$exception.handled(1)
			$errors[^MAIN:objAuth.decodeError[]]
			<p>При сохранении новых параметров пользователя возникли следующие проблемы: ^errors.menu{$errors.name}[, ].</p>
		}	
	}{
		^try{
			^rem{ *** регистрация нового пользователя *** }
			$hTemp[$form:fields]
			$hTemp.[auth.rights](1)
			^MAIN:objAuth.insertUser[$hTemp]
			^rem{ *** если регистрация прошла успешно - логиним пользователя *** }
			^MAIN:objAuth.logon[
				$form:fields
				$.[auth.logon][do]
			]
			<p>Пользователь успешно зарегистрирован.</p>
		}{
			$exception.handled(0)
			$errors[^MAIN:objAuth.decodeError[]]
			<p>При регистрации нового пользователя возникли следующие проблемы: ^errors.menu{$errors.name}[, ].</p>
		}
	}
}{$hParams.body}
</block_content>
#end @mRegisterRun[hParams]