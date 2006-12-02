$USER[^MAIN:objAuth.getUser[$.user_id[$form:edit]]]
$USER_GROUPS[^MAIN:objAuth.getUserGroups[^form:edit.int(0)]]
^rem{ *** выводим форму *** }
<form method="post">
<table>
  <tr>
    <td>id      $USER.id</td>
    <td>user_id $USER.user_id</td>
  </tr><tr>
    <td>name  <br /> <field type="text" name="name"  value="$USER.name" /> </td>
    <td>email <br /> <field type="text" name="email" value="$USER.email" /></td>
  </tr><tr>
    <td>description <br /> <field type="text" name="description" value="$USER.description" /></td>
    <td>rights (6)   <br /> <field type="text" name="rights"      value="$USER.rights" />     </td>
  </tr><tr>
    <td>passwd      <br /> <field type="text" name="passwd"      value="$USER.passwd" />     </td>
    <td>dt_register <br /> <field type="text" name="dt_register" value="$USER.dt_register" /></td>
  </tr><tr>
    <td>dt_logon    <br /> <field type="text" name="dt_logon"    value="$USER.dt_logon" /></td>
    <td>dt_logout   <br /> <field type="text" name="dt_register" value="$USER.dt_logout" /></td>
  </tr><tr>
    <td>fio         <br /> <field type="text" name="fio"         value="$USER.fio" /></td>
    <td>adress      <br /> <field type="text" name="adress"      value="$USER.adress" /></td>
  </tr><tr>
    <td>telefon     <br /> <field type="text" name="telefon"     value="$USER.telefon" /></td>
    <td>www         <br /> <field type="text" name="www"         value="$USER.www" />    </td>
  </tr><tr>
    <td colspan="2">
      <select name="work_place">
        <option value="Не указан">Выберите отдел:</option>
        <option value="Бухгалтерия">Бухгалтерия</option>
        <option value="Отдел ИТ">Отдел ИТ</option>
        <option value="Экономический отдел">Экономический отдел</option>
        <option value="Отдел кредитования">Отдел кредитования</option>
        <option value="ОПиКР">ОПиКР</option>
        <option value="Торговый отдел">Торговый отдел</option>
        <option value="Склад ТО">Склад ТО</option>
      </select>
   </td></tr><tr>
    <td>
      ^rem{ *** выводим список групп, в которых состоит пользователь *** }
      <user-groups>
        ^USER_GROUPS.menu{
          <item id="$USER_GROUPS.group_id">
            $USER_GROUPS.name
          </item>
	}
     </user-groups>
   </td>
   <td>
     <groups-list>
       ^MAIN:objAuth.groups.menu{
         ^if(!^USER_GROUPS.locate[group_id;$MAIN:objAuth.group_id]){
           <item id="$MAIN:objAuth.groups.group_id">
             $MAIN:objAuth.groups.name
           </item>
        }
      }
    </groups-list>
  </td>
  </tr><tr><td colspan="2"><field type="submit" value="Сохранить" name="user_edit_action" /></td></tr>
  <tr><td colspan="2">
        Задать новый пароль:
        <field type="text" value="" name="new_passwd" />
        <field type="submit" value="Заменить" name="user_passwd_action" />
      </td></tr>
</table>
</form>
^rem{ *** обработчики форм *** }
^if(def $form:user_edit_action){
  ^MAIN:objSQL.sql[void]{
    UPDATE 
      auser
    SET
      name        = '$form:name',
      email       = '$form:email',
      description = '$form:description',
      rights      = '$form:rights',
      fio         = '$form:fio',
      adress      = '$form:adress',
      telefon     = '$form:telefon',
      work_place  = '$form:work_place',
      www         = '$form:www'
    WHERE
      auser_id="$USER.id"
  }
  $response:location[/]
}
^if(def $form:user_passwd_action){
  ^MAIN:objSQL.sql[void]{
    UPDATE 
      auser
    SET
      passwd = '^MAIN:objAuth.cryptPassword[$form:new_passwd]'
    WHERE
      auser_id="$USER.id"
  }
  $response:location[/close.html]
}


^rem{ ^MAIN:pSQL.sql[void]{UPDATE auser SET passwd = '^auth_data.cryptPassword[$password]' WHERE auser_id = 3} 
^rem{ добавление пользователя в группу }
^if(def $form:gid && ^auth.groups.locate[group_id;$form:gid] && def $form:addgroup && def $form:id){
	^auth.addUsertGroup[$form:fields]
}

^rem{ удаление пользователя из группы }
^if(def $form:gid && def $form:deluser){
	^auth.delUserfGroup[$form:fields]
}

^rem{ *** выдаем антикеширующие заголовки *** }
^auth.setExpireHeaders[]
$is_show_form(1)
$status_message[]

^if(def $form:do){
	^try{
		^rem{ *** сохраняем параметры существующего пользователя *** }
		^auth.updateUserAdmin[$form:fields]
		$status_message[Параметры пользователя сохранены.]
		$is_show_form(0)
	}{
		$exception.handled(1)
		$errors[^auth.decodeError[]]
		$status_message[При сохранении новых параметров пользователя возникли следующие проблемы: ^errors.menu{$errors.name}[, ].]
	}
}

^if(def $form:id || def $form:do){
	<auser>
	^rem{если есть сообщение о регистрации или о ошибке}
	^if($status_message ne ""){<status ^if($errors){error="1"}>$status_message</status>}
	
	^if($is_show_form && def $form:id){
		$_user[^auth.getUser[
			$.user_id(^form:id.int(0))
		]]
		^if($_user){
			^if(!def $form:order){$orderBy[name]}{$orderBy[$form:order]}
			^rem{ *** показываем форму изменения параметров *** }
			^auth.xmlFormProfile[
				$.fields[
					$.[auth.name][$_user.name]
					$.[auth.email][$_user.email]
				]
				^rem{ *** дополнительные поля *** }
				$.addon[
					<field type="hidden" name="order" value="$orderBy"/>
					<field type="hidden" name="id" value="$_user.id"/>
					<field type="text" name="auth.fio" value="$_user.fio"/>
					<field type="text" name="auth.www" value="$_user.www"/>
					<field type="text" name="auth.adress" value="$_user.adress"/>
					<field type="text" name="auth.work_place" value="$_user.work_place"/>
					<field type="text" name="auth.work_position" value="$_user.work_position"/>
					<field type="text" name="auth.dt_birth" value="$_user.dt_birth"/>
				]
				$.tag_name[auth-profile]
			]
			^rem{ *** выводим список групп, в которых состоит пользователь *** }
			$userGroups[^auth.getUserGroups[^form:id.int(0)]]
			<user-groups>
			^userGroups.menu{
				<item id="$userGroups.group_id">
					<name>$userGroups.name</name>
				</item>
			}
			</user-groups>
			^rem{ *** выводим список групп, в которых пользователь не состоит *** }
			<groups-list>
			^auth.groups.menu{
				^if(!^userGroups.locate[group_id;$auth.groups.group_id]){
					<item id="$auth.groups.group_id">
						<name>$auth.groups.name</name>
					</item>
				}
			}
			</groups-list>
		}
	}
	</auser>
}}