<block_content>
^rem{ *** объект авторизации $MAIN:objAuth ***}
^rem{ *** выдаем антикеширующие заголовки *** }
^MAIN:objAuth.setExpireHeaders[]
$is_show_form(1)
^if(def $form:do){
  ^if($MAIN:objAuth.is_logon){
    ^try{
      ^rem{ *** сохраняем параметры существующего пользователя *** }
      ^MAIN:objAuth.updateUser[$form:fields]
      <p>Параметры пользователя сохранены.</p>
      $is_show_form(0)
    }{
      $exception.handled(1)
      $errors[^MAIN:objAuth.decodeError[]]
      <p>При сохранении новых параметров пользователя возникли следующие проблемы: ^errors.menu{$errors.name}[, ].</p>
   }
   }{
     ^try{
       ^rem{ *** регистрация нового пользователя *** }
       ^MAIN:objAuth.insertUser[$form:fields]
       ^rem{ *** если регистрация прошла успешно - логиним пользователя *** }
       ^MAIN:objAuth.logon[
         $form:fields
	 $.[auth.logon][do]
       ]
       <p>Пользователь успешно зарегистрирован.</p>
       $is_show_form(0)
     }{
       $exception.handled(1)
       $errors[^MAIN:objAuth.decodeError[]]
       <p>При регистрации нового пользователя возникли следующие проблемы: ^errors.menu{$errors.name}[, ].</p>
     }
   }
 }

^if($is_show_form){
  ^rem{ *** если надо показываем форму регистрации/изменения параметров *** }
^MAIN:objAuth.xmlFormProfile[
				$.fields[
					$.[auth.name][$MAIN:objAuth.user.name]
					$.[auth.email][$MAIN:objAuth.user.email]
				]
				^rem{ *** дополнительные поля *** }
				$.addon[
					<field type="hidden" name="id" value="$MAIN:objAuth.user.id"/>
				]
				$.tag_name[auth-profile]
			]
}
</block_content>