$USERS[^MAIN:objAuth.getAllUsers[]]
<form name="test_form" method="post">
<table>
<tr>
  <td>Выберите период:</td>
  <td>
    <script language="JavaScript">
      var cal1 = new calendar('$form:datetime_0', 'test_form', null, '2002-05-11', 5);
    </script>
    <script language="JavaScript">
      var cal2 = new calendar('$form:datetime_1', 'test_form', null, '2002-05-11', 5);
    </script>
  </td>
</tr>
<tr>
  <td>Выберите сотрудника:</td>
  <td>
    ^USERS.sort{$USERS.fio}
    <select name="user_id">
      <![CDATA[<option value="0" ^if($form:user_id == 0){ selected } >Все сотрудники</option>]]>
      ^USERS.menu{
        <![CDATA[<option value="$USERS.id" ^if($form:user_id == $USERS.id){ selected } >$USERS.fio</option>]]>
      }
    </select>
  </td>
</tr>
<tr>
  <td>Выберите отдел:</td>
  <td>
    <select name="work_place">
      <![CDATA[<option value="0"                   ^if($form:work_place eq '0'){ selected } >Все отделы</option>]]>
      <![CDATA[<option value="1"                   ^if($form:work_place eq '1'){ selected } >Без отдела</option>]]>
      <![CDATA[<option value="Бухгалтерия"         ^if($form:work_place eq 'Бухгалтерия'){ selected } >Бухгалтерия</option>]]>
      <![CDATA[<option value="Отдел ИТ"            ^if($form:work_place eq 'Отдел ИТ'){ selected } >Отдел ИТ</option>]]>
      <![CDATA[<option value="Экономический отдел" ^if($form:work_place eq 'Экономический отдел'){ selected } >Экономический отдел</option>]]>
      <![CDATA[<option value="Отдел кредитования"  ^if($form:work_place eq 'Отдел кредитования'){ selected } >Отдел кредитования</option>]]>
      <![CDATA[<option value="ОПиКР"               ^if($form:work_place eq 'ОПиКР'){ selected } >ОПиКР</option>]]>
      <![CDATA[<option value="Торговый отдел"      ^if($form:work_place eq 'Торговый отдел'){ selected } >Торговый отдел</option>]]>
      <![CDATA[<option value="Склад ТО"            ^if($form:work_place eq 'Склад ТО'){ selected } >Склад ТО</option>]]>
    </select>
  </td>
</tr>
<tr>
  <td>Отметьте события:</td>
  <td>
    <![CDATA[<input type="checkbox" name="event1" value="1" ^if(def $form:event1){ checked } /> Прибытие  на работу<br />]]>
    <![CDATA[<input type="checkbox" name="event2" value="1" ^if(def $form:event2){ checked } /> Отбытие по работе <br />]]>
    <![CDATA[<input type="checkbox" name="event3" value="1" ^if(def $form:event3){ checked } /> Возвращение по работе <br />]]>
  </td>
</tr>
<tr>
  <td> Поля запроса:</td>
  <td>
    <br />
    <table><tr><td>
    <![CDATA[<input type="checkbox" name="field1" value="1" checked /> Дата<br />]]>
    <![CDATA[<input type="checkbox" name="field2" value="1" checked /> Время <br />]]>
    <![CDATA[<input type="checkbox" name="field3" value="1" checked /> Отдел <br />]]>
    </td><td>
    <![CDATA[<input type="checkbox" name="field4" value="1" checked /> Сотрудник <br />]]>
    <![CDATA[<input type="checkbox" name="field5" value="1" checked /> Событие <br />]]>
    <![CDATA[<input type="checkbox" name="field6" value="1" checked /> Место <br />]]>
    </td></tr><tr><td colspan="2">
    <![CDATA[<input type="checkbox" name="field7" value="1" checked /> Причина <br />]]>
    </td></tr></table>
  </td>
</tr>
<tr>
  <td></td>
  <td><br /><field type="submit" name="tabel_action" value="Сформировать" /></td>
</tr>
</table>
</form>

^if(def $form:tabel_action){
$USERS[^MAIN:objSQL.sql[table][
  SELECT
    auser.auser_id AS id,
    auser.fio,
    auser.work_place
  FROM
    auser
]]
$USERS_HASH[^USERS.hash[id]]
$TABEL[^MAIN:objSQL.sql[table][
  SELECT
    m_b_time_control.user_id,
    m_b_time_control.date,
    m_b_time_control.time,
    m_b_time_control.event,
    m_b_time_control.out_place,
    m_b_time_control.comment
  FROM
    m_b_time_control
  WHERE
    date BETWEEN '$form:datetime_0' and '$form:datetime_1'
    ^switch[$form:user_id]{
      ^case[0]{}
      ^case[DEFAULT]{and user_id = '$form:user_id'}
    }
    ^if(!($form:work_place eq 0)){
      and user_id in ( 0
        ^USERS.menu{
          ^if($form:work_place eq $USERS.work_place){ , $USERS.id}
        }
      )
    }
    and event in ( 0 
      ^if(def $form:event1){, 1}
      ^if(def $form:event2){, 2}
      ^if(def $form:event3){, 3}
    )
]]
<print>
  <center><b> Период с $form:datetime_0 по $form:datetime_1 </b> </center>
  ^if(def $form:user_id){ Сотрудник:     
    ^switch[$form:user_id]{
      ^case[0]{все сотрудники , }
      ^case[DEFAULT]{$USERS_HASH.[$form:user_id].fio , }
    }}
  ^if(def $form:work_place){<br /> Отдел: $form:work_place}
  <table width="100%">
    <tr class="color1">
      ^if(def $form:field1){<td>Дата:</td>}
      ^if(def $form:field2){<td>Время:</td>}
      ^if(def $form:field3){<td>Отдел:</td>}
      ^if(def $form:field4){<td>Сотрудник:</td>}
      ^if(def $form:field5){<td>Событие:</td>}
      ^if(def $form:field6){<td>Место:</td>}
      ^if(def $form:field7){<td>Причина:</td>}
    </tr>
  ^TABEL.menu{
    <tr class="color2">
      ^if(def $form:field1){<td>$TABEL.date</td>}
      ^if(def $form:field2){<td>$TABEL.time</td>}
      ^if(def $form:field3){<td>$USERS_HASH.[$TABEL.user_id].work_place</td>}
      ^if(def $form:field4){<td><user_cart id="$TABEL.user_id">$USERS_HASH.[$TABEL.user_id].fio</user_cart></td>}
      ^if(def $form:field5){<td>
        ^switch[$TABEL.event]{
          ^case[1]{Прибытие на работу}
          ^case[2]{Отбытие по работе}
          ^case[3]{Возвращение по работе}
        }
      </td>}
      ^if(def $form:field6){<td>$TABEL.out_place</td>}
      ^if(def $form:field7){<td>$TABEL.comment</td>}
    </tr>
  }
  </table>
</print>
}{
}