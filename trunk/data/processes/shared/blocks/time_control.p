<block_content>
<first>
^if($MAIN:objAuth.is_logon){
  $date_now[^date::now[]]
  $date_event[^date::create($date_now.year;$date_now.month;$date_now.day)]
  ^rem{ *** �������� ��������� �� ���� *** }
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
    ^rem{ *** ���������� ��������� (1) *** }
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
         '�������� 19',
         '������ �� ������'
       )
     }
     ^rem{ *** �� ������ ������ ������ �������� *** }
     ^MAIN:objSQL.void{
       DELETE from
         m_b_time_out
       WHERE
         user_id = '$MAIN:objAuth.user.id'
     }
     $response:location[/]  
   }
    ^rem{ *** ����� ��������� ������ *** }
    ������������ <user_cart id="$MAIN:objAuth.user.user_id"><b>$MAIN:objAuth.user.fio</b></user_cart> <br /><br />
    <print>
    ^use[dtf.p]
    ������:  <b>^dtf:format[%A %d %b %Y]</b> <br />
    ���� �������� ���� ������������� �: <b> $EVENT.time </b> <br /><br />
    ������ ����� ����������� ������: <br />
    <table cellspacing="3" cellpadding="5" width="100%">
    <tr class="color1"><td>�����</td><td>�������</td><td>�������</td><td>�����</td></tr>
    ^EVENT.menu{
      <tr class="color2">
        <td>$EVENT.time</td>
        <td>
          ^switch[$EVENT.event]{
            ^case[1]{������ �� ������}
            ^case[2]{�������}
            ^case[3]{��������}
          }
        </td>
        <td>$EVENT.comment</td>
	<td>$EVENT.out_place</td>
      </tr>
    }
    </table><br />
    </print>
    ^EVENT.offset(-1)
    �� ���������� <b> $EVENT.out_place </b> <br />
    ���������� �� ����������� �� ������ ���������� <a href="/static/" alt="������">�����</a>
    ^if($EVENT.event == 2){
    ^rem{ *** ����� �������� *** }
    <fieldset><legend>����� ��������</legend>
    <form method="post">
    <field type="submit" name="time_in" value="�������� ��������" />
    </form>
    </fieldset>
    }{
    ^rem{ *** ����� ������� *** }
    <fieldset><legend>����� �������</legend>
    <form method="post">
    <table><tr><td>
    ������� ����� ����� �������... <br />
    <textarea name="out_place" wrap="virtual" cols="50" rows="3"></textarea> <br />
    </td><td>
    ������� ����� ������� �������... <br />
    <textarea name="comment" wrap="virtual" cols="50" rows="3"></textarea> <br />
    </td></tr></table><br />
    <field type="submit" name="time_out" value="�������� �������" /></form>
    </fieldset>
    }
}{
 <attention>��������� ���� ��� <a href="reg.html" alt="�����������">�����������������!</a></attention>
 <br /> <comment>(� ������ ������ ������ ���������� � ����������� ������ ��)</comment>
}
</first>
^rem{ *** ��������� ���� *** }
^if(def $form:time_out){
  ^if(def $form:out_place && def $form:comment){
    ^rem{ *** ���������� ������� *** }
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
    <font color="red"><b>�� ��������� ����������� ���� �����!</b></font>
    }
  }
^if(def $form:time_in){
  ^rem{ *** ���������� �������� *** }
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
       '�������� 19',
       '������ �� ������'
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