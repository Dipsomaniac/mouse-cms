$date_now[^date::now[]]
$date_event[^date::create($date_now.year;$date_now.month;$date_now.day)]

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
    date = '^date_event.sql-string[]'
  ]]
$EVENT_HASH[^EVENT.hash[user_id][$.distinct[tables]]]
$EVENT_OUT[^MAIN:objSQL.sql[table][
  SELECT 
    user_id
  FROM
    m_b_time_out
  ]]
$USERS[^MAIN:objSQL.sql[table][
  SELECT
    auser.auser_id AS id,
    auser.fio
  FROM
    auser
]]
$USERS_HASH[^USERS.hash[id]]
<block_content>
^if(def $EVENT_OUT){
  ������������� ���������: <br />
  <table cellspacing="3" cellpadding="5" width="100%">
    <tr class="color1"><td>���������</td><td>�����</td><td>�����</td><td>�������</td></tr>
    ^EVENT_OUT.menu{
      ^EVENT_HASH.[$EVENT_OUT.user_id].offset(-1)
      <tr class="color2">
        <td><user_cart id="$EVENT_HASH.[$EVENT_OUT.user_id].user_id">$USERS_HASH.[$EVENT_HASH.[$EVENT_OUT.user_id].user_id].fio</user_cart></td>
        <td>$EVENT_HASH.[$EVENT_OUT.user_id].time</td>
        <td>$EVENT_HASH.[$EVENT_OUT.user_id].out_place</td>
        <td>$EVENT_HASH.[$EVENT_OUT.user_id].comment</td>
      </tr>
      }
  </table><br />
}{������ �� ������������� ���������� �� ����������. <br />}
<a href="/static/tabel.html">[������� �� ������]</a> <a href="/static/tabel.html">[������� �� �������]</a> <a href="/static/tabel.html">[������� �� ����]</a>
</block_content>