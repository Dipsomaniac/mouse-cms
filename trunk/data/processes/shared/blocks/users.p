  $date_now[^date::now[]]
  $date_event[^date::create($date_now.year;$date_now.month;$date_now.day)]
  ^rem{ *** получаем список пользователей *** }
  $USERS[^MAIN:objSQL.sql[table][
    SELECT
      auser_id AS id,
      name,
      fio,
      telefon,
      work_place,
      email,
      is_published
    FROM
      auser
    ORDER BY
      fio
  ]]

<block_content>
  <print>
    <titul>Список пользователей</titul>
    <table width="100%">
    <tr class="color1">
      <td>Ф.И.О.</td>
      <td>Отдел</td>
      <td>Телефон</td>
      <td>Email</td>
      <td>Ред.</td>
    </tr>
    ^USERS.menu{
    ^if(def $USERS.fio){
    <tr>
      <td><user_cart id="$USERS.id">$USERS.fio</user_cart></td>
      <td>$USERS.work_place</td>
      <td>^if($USERS.telefon eq '0'){не указан}{$USERS.telefon}</td>
      <td><a href="mailto:$USERS.email">$USERS.email</a></td>
      <td><a href="#" onclick="window.open('/admin/user_edit.html?edit=$USERS.id','bautombil','toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,width=500,height=420,resizable=yes')">[ edit ]</a></td>
    </tr>
    }
    }
    </table>
  </print>
</block_content>