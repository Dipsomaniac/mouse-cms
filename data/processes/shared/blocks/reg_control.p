<block_content>
^rem{ *** ������ ����������� $MAIN:objAuth ***}
^rem{ *** ������ �������������� ��������� *** }
^MAIN:objAuth.setExpireHeaders[]
$is_show_form(1)
^if(def $form:do){
  ^if($MAIN:objAuth.is_logon){
    ^try{
      ^rem{ *** ��������� ��������� ������������� ������������ *** }
      ^MAIN:objAuth.updateUser[$form:fields]
      <p>��������� ������������ ���������.</p>
      $is_show_form(0)
    }{
      $exception.handled(1)
      $errors[^MAIN:objAuth.decodeError[]]
      <p>��� ���������� ����� ���������� ������������ �������� ��������� ��������: ^errors.menu{$errors.name}[, ].</p>
   }
   }{
     ^try{
       ^rem{ *** ����������� ������ ������������ *** }
       ^MAIN:objAuth.insertUser[$form:fields]
       ^rem{ *** ���� ����������� ������ ������� - ������� ������������ *** }
       ^MAIN:objAuth.logon[
         $form:fields
	 $.[auth.logon][do]
       ]
       <p>������������ ������� ���������������.</p>
       $is_show_form(0)
     }{
       $exception.handled(1)
       $errors[^MAIN:objAuth.decodeError[]]
       <p>��� ����������� ������ ������������ �������� ��������� ��������: ^errors.menu{$errors.name}[, ].</p>
     }
   }
 }

^if($is_show_form){
  ^rem{ *** ���� ���� ���������� ����� �����������/��������� ���������� *** }
^MAIN:objAuth.xmlFormProfile[
				$.fields[
					$.[auth.name][$MAIN:objAuth.user.name]
					$.[auth.email][$MAIN:objAuth.user.email]
				]
				^rem{ *** �������������� ���� *** }
				$.addon[
					<field type="hidden" name="id" value="$MAIN:objAuth.user.id"/>
				]
				$.tag_name[auth-profile]
			]
}
</block_content>