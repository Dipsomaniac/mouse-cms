<block_content>
<first>
^if($MAIN:objAuth.is_logon){
  $date_now[^date::now[]]
  $date_event[^date::create($date_now.year;$date_now.month;$date_now.day)]
  ^rem{ *** получаем обращения за день *** }
  $EVENT[^MAIN:objSQL.sql[table][
    SELECT 
      m_b_time_control.id,
      m_b_time_control.date,
      m_b_time_control.time,
      m_b_time_control.user_id,
      m_b_time_control.event,
      m_b_time_control.comment,
      m_b_time_control.out_place
    FROM
      m_b_time_control
    WHERE
      user_id = '$MAIN:objAuth.user.id'
      and
      date = '^date_event.sql-string[]'
  ]]
  ^if(def $EVENT){
  }{
    ^rem{ *** записываем обращение (1) *** }
    ^MAIN:objSQL.void{
      INSERT into
        m_b_time_control
      (
         user_id,
         date,
         time,
         event,
         out_place,
         comment
       )
         VALUES
       (
         '$MAIN:objAuth.user.id' ,
         '^date_now.sql-string[]' ,
         '^date_now.sql-string[]' ,
         '1',
         'Калинина 19',
         'Прибыл на работу'
       )
     }
     ^rem{ *** на всякий случай чистим прибытие *** }
     ^MAIN:objSQL.void{
       DELETE from
         m_b_time_out
       WHERE
         user_id = '$MAIN:objAuth.user.id'
     }
     $response:location[/]  
   }
    ^rem{ *** вывод служебной панели *** }
    Здравствуйте <user_cart id="$MAIN:objAuth.user.user_id"><b>$MAIN:objAuth.user.fio</b></user_cart> <br /><br />
    <print>
    ^use[dtf.p]
    Сейчас:  <b>^dtf:format[%A %d %b %Y]</b> <br />
    Ваше прибытие было зафиксировано в: <b> $EVENT.time </b> <br /><br />
    График вашей сегодняшней работы: <br />
    <table cellspacing="3" cellpadding="5" width="100%">
    <tr class="color1"><td>Время</td><td>Событие</td><td>Причина</td><td>Место</td></tr>
    ^EVENT.menu{
      <tr class="color2">
        <td>$EVENT.time</td>
        <td>
          ^switch[$EVENT.event]{
            ^case[1]{Прибыл на работу}
            ^case[2]{Отбытие}
            ^case[3]{Прибытие}
          }
        </td>
        <td>$EVENT.comment</td>
	<td>$EVENT.out_place</td>
      </tr>
    }
    </table><br />
    </print>
    ^EVENT.offset(-1)
    Вы находитесь <b> $EVENT.out_place </b> <br />
    Информацию по сотрудникам вы можете посмотреть <a href="/static/" alt="Отчеты">здесь</a>
    ^if($EVENT.event == 2){
    ^rem{ *** форма прибытия *** }
    <fieldset><legend>Форма прибытия</legend>
    <form method="post">
    <field type="submit" name="time_in" value="отметить прибытие" />
    </form>
    </fieldset>
    }{
    ^rem{ *** форма отбытия *** }
    <fieldset><legend>Форма отбытия</legend>
    <form method="post">
    <table><tr><td>
    Введите здесь место отбытия... <br />
    <textarea name="out_place" wrap="virtual" cols="50" rows="3"></textarea> <br />
    </td><td>
    Введите здесь причину отбытия... <br />
    <textarea name="comment" wrap="virtual" cols="50" rows="3"></textarea> <br />
    </td></tr></table><br />
    <field type="submit" name="time_out" value="отметить отбытие" /></form>
    </fieldset>
    }
}{
 <attention>Выполните вход или <a href="reg.html" alt="регистрация">зарегистрируйтесь!</a></attention>
 <br /> <comment>(в случае потери пароля обратитесь к сотрудникам отдела ИТ)</comment>
}
</first>
^rem{ *** обработка форм *** }
^if(def $form:time_out){
  ^if(def $form:out_place && def $form:comment){
    ^rem{ *** записываем отбытие *** }
    ^MAIN:objSQL.void{
      INSERT into
        m_b_time_control 
      (
         user_id,
         date,
         time,
         event,
         out_place,
         comment
       )
         VALUES
       (
         '$MAIN:objAuth.user.id' ,
         '^date_now.sql-string[]' ,
         '^date_now.sql-string[]' ,
         '2',
         '$form:out_place',
         '$form:comment'
       )
     }
    ^MAIN:objSQL.void{
      INSERT into
        m_b_time_out
      (
         user_id
      )
         VALUES
       (
         '$MAIN:objAuth.user.id'
       )
     }
     $response:location[/]  
    }{
    <font color="red"><b>Не заполнены необходимые поля формы!</b></font>
    }
  }
^if(def $form:time_in){
  ^rem{ *** записываем прибытие *** }
  ^MAIN:objSQL.void{
    INSERT into
      m_b_time_control
    (
       user_id,
       date,
       time,
       event,
       out_place,
       comment
     )
       VALUES
     (
       '$MAIN:objAuth.user.id' ,
       '^date_now.sql-string[]' ,
       '^date_now.sql-string[]' ,
       '3',
       'Калинина 19',
       'Прибыл на работу'
     )
   }
  ^MAIN:objSQL.void{
    DELETE from
      m_b_time_out
    WHERE
      user_id = '$MAIN:objAuth.user.id'
   }
   $response:location[/]
}
</block_content>