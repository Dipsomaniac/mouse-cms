$USERS[^MAIN:objAuth.getAllUsers[]]
<form name="test_form" method="post">
<table>
<tr>
  <td>�������� ������:</td>
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
  <td>�������� ����������:</td>
  <td>
    ^USERS.sort{$USERS.fio}
    <select name="user_id">
      <![CDATA[<option value="0" ^if($form:user_id == 0){ selected } >��� ����������</option>]]>
      ^USERS.menu{
        <![CDATA[<option value="$USERS.id" ^if($form:user_id == $USERS.id){ selected } >$USERS.fio</option>]]>
      }
    </select>
  </td>
</tr>
<tr>
  <td>�������� �����:</td>
  <td>
    <select name="work_place">
      <![CDATA[<option value="0"                   ^if($form:work_place eq '0'){ selected } >��� ������</option>]]>
      <![CDATA[<option value="1"                   ^if($form:work_place eq '1'){ selected } >��� ������</option>]]>
      <![CDATA[<option value="�����������"         ^if($form:work_place eq '�����������'){ selected } >�����������</option>]]>
      <![CDATA[<option value="����� ��"            ^if($form:work_place eq '����� ��'){ selected } >����� ��</option>]]>
      <![CDATA[<option value="������������� �����" ^if($form:work_place eq '������������� �����'){ selected } >������������� �����</option>]]>
      <![CDATA[<option value="����� ������������"  ^if($form:work_place eq '����� ������������'){ selected } >����� ������������</option>]]>
      <![CDATA[<option value="�����"               ^if($form:work_place eq '�����'){ selected } >�����</option>]]>
      <![CDATA[<option value="�������� �����"      ^if($form:work_place eq '�������� �����'){ selected } >�������� �����</option>]]>
      <![CDATA[<option value="����� ��"            ^if($form:work_place eq '����� ��'){ selected } >����� ��</option>]]>
    </select>
  </td>
</tr>
<tr>
  <td>�������� �������:</td>
  <td>
    <![CDATA[<input type="checkbox" name="event1" value="1" ^if(def $form:event1){ checked } /> ��������  �� ������<br />]]>
    <![CDATA[<input type="checkbox" name="event2" value="1" ^if(def $form:event2){ checked } /> ������� �� ������ <br />]]>
    <![CDATA[<input type="checkbox" name="event3" value="1" ^if(def $form:event3){ checked } /> ����������� �� ������ <br />]]>
  </td>
</tr>
<tr>
  <td> ���� �������:</td>
  <td>
    <br />
    <table><tr><td>
    <![CDATA[<input type="checkbox" name="field1" value="1" checked /> ����<br />]]>
    <![CDATA[<input type="checkbox" name="field2" value="1" checked /> ����� <br />]]>
    <![CDATA[<input type="checkbox" name="field3" value="1" checked /> ����� <br />]]>
    </td><td>
    <![CDATA[<input type="checkbox" name="field4" value="1" checked /> ��������� <br />]]>
    <![CDATA[<input type="checkbox" name="field5" value="1" checked /> ������� <br />]]>
    <![CDATA[<input type="checkbox" name="field6" value="1" checked /> ����� <br />]]>
    </td></tr><tr><td colspan="2">
    <![CDATA[<input type="checkbox" name="field7" value="1" checked /> ������� <br />]]>
    </td></tr></table>
  </td>
</tr>
<tr>
  <td></td>
  <td><br /><field type="submit" name="tabel_action" value="������������" /></td>
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
  <center><b> ������ � $form:datetime_0 �� $form:datetime_1 </b> </center>
  ^if(def $form:user_id){ ���������:     
    ^switch[$form:user_id]{
      ^case[0]{��� ���������� , }
      ^case[DEFAULT]{$USERS_HASH.[$form:user_id].fio , }
    }}
  ^if(def $form:work_place){<br /> �����: $form:work_place}
  <table width="100%">
    <tr class="color1">
      ^if(def $form:field1){<td>����:</td>}
      ^if(def $form:field2){<td>�����:</td>}
      ^if(def $form:field3){<td>�����:</td>}
      ^if(def $form:field4){<td>���������:</td>}
      ^if(def $form:field5){<td>�������:</td>}
      ^if(def $form:field6){<td>�����:</td>}
      ^if(def $form:field7){<td>�������:</td>}
    </tr>
  ^TABEL.menu{
    <tr class="color2">
      ^if(def $form:field1){<td>$TABEL.date</td>}
      ^if(def $form:field2){<td>$TABEL.time</td>}
      ^if(def $form:field3){<td>$USERS_HASH.[$TABEL.user_id].work_place</td>}
      ^if(def $form:field4){<td><user_cart id="$TABEL.user_id">$USERS_HASH.[$TABEL.user_id].fio</user_cart></td>}
      ^if(def $form:field5){<td>
        ^switch[$TABEL.event]{
          ^case[1]{�������� �� ������}
          ^case[2]{������� �� ������}
          ^case[3]{����������� �� ������}
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