^if(def $lparams.param.admin){^mAdmin[$lparams]}{^mView[$lparams]}



#################################################################################################
# управление голосованиями
@mView[hParams][now;poll;iInc;key;value]
# определение текущего голосования
$now(^hParams.param.poll_id.int(1))
# загрузка хэша запрошенного голосования
$crdPoll[^curd::init[
	$.name[poll]
	$.where[ poll_id = $now]
	$.order[]
	$.names[
		$.[poll.poll_id][id]
		$.[poll.title][]
		$.[poll.body][]
		$.[poll.dt][]
		$.[poll.dt_finish][]
		$.[poll.result][]
		$.[IF(dt_finish > NOW(), 1, 0)][status]
	]
	$.h(1)
]]
# получение общего результата голосования
$poll[$.result[^getStrToHash[$crdPoll.hash.$now.result]]]
# попытка получения результата пользователя
^if(def $form:answer){
# если куки нету обрабатываем ответ
	^if(!^cookie:poll_$now.int(0)){
# 		увеличиваем результат
		^poll.result.[$form:answer].inc[]
# 		запрос к MYSQL
		^MAIN:objSQL.void{ UPDATE poll SET result = '^poll.result.foreach[key;value]{^$.$key^($value^) }' WHERE poll_id = $crdPoll.hash.$now.id }
# 		очистка кэша
		^MAIN:objSQL.clear[$crdPoll.cachename]
	}
#	запись голосования в куку
	$cookie:poll_answer_$now[$form:answer]
	$cookie:poll_$now(1)
#	результаты пользователя
	$poll.poll_id[$cookie:poll_$now]
	$poll.poll_answer[$cookie:poll_answer_$now]
}{
#	результаты пользователя
	$poll.poll_id[$cookie:poll_$now]
	$poll.poll_answer[$cookie:poll_answer_$now]
}
# вывод голосования
<block_content>
<poll 
	id="$crdPoll.hash.$now.id" 
	title="$crdPoll.hash.$now.title"
	dt="$crdPoll.hash.$now.dt"
	dt_finish="$crdPoll.hash.$now.dt_finish"
	action="$SYSTEM.path"
	^if(^poll.poll_id.int(0) || !$crdPoll.hash.$now.status){mode="1"}{mode="0"}
>
^untaint[as-is]{
$crdPoll.hash.$now.body
^try{
	^poll.result.foreach[key;value]{$iInc(^eval($iInc + $value))}
	<count>$iInc</count>
	^poll.result.foreach[key;value]{<result id="$key" value="$value" div="^if($value){$key(^eval($value/$iInc*100))^key.format[%.0f]}{0}"/>}
}{
	$exception.handled(0)
}}
</poll>
</block_content>
#end @mPoll[hParams][poll;iInc;key;value]



#################################################################################################
# администрирование голосований
@mAdmin[hParams][hAction]
# -----------------------------------------------------------------------------------------------
# определение вывода в зависимости от запроса
^if(def $form:action){
# -----------------------------------------------------------------------------------------------
#	вывод формы редактирования
	$hAction[^mGetAction[$form:action]]
#	загрузка данных
$crdPoll[^curd::init[
	$.name[poll]
	$.order[]
	$.names[
		$.[poll.poll_id][id]
		$.[poll.title][]
		$.[poll.body][]
		$.[poll.dt][]
		$.[poll.dt_finish][]
		$.[poll.result][]
		$.[IF(dt_finish > NOW(), 1, 0)][status]
	]
	$.h(1)
]]
	<form method="post" action="$SYSTEM.path" name="form_content" id="form_content" enctype="multipart/form-data"
	label="MOUSE CMS | Голосование | $hAction.label" >
	<tabs>
	<tab id="section-1" name="Основное">
		<field type="text" name="title" label="Название" description=" Заголовок сообщения " class="long">$crdPoll.hash.[$form:id].title</field>
		<field type="text" name="dt_finish" label="Дата окончания" description=" Дата завершения голосования " class="medium">^if(def $crdPoll.hash.[$form:id].dt_finish){$crdPoll.hash.[$form:id].dt_finish}{$SYSTEM.date}</field>
		<field type="textarea" name="body" label="Текст"   description="Содержание сообщения">$crdPoll.hash.[$form:id].body</field>
		<field type="textarea" name="result" label="Результаты"   description="Результаты голосования">$crdPoll.hash.[$form:id].result</field>
		^if($hAction.i & 6){
			<field type="hidden" name="dt">$SYSTEM.date</field>
		}
		</tab>
	</tabs>
^form_engine[
	^$.where[poll_id]
	^$.poll_id[$form:id]
	^$.tables[^$.main[poll]]
	^if($hAction.i & 6){^$.action[insert]}
	^if($hAction.i & 1){^$.action[update]}
]
	</form>
}{
# -----------------------------------------------------------------------------------------------
# вывод голосований
$crdPoll[^curd::init[
	$.name[poll]
	$.order[]
	$.s(20)
	$.names[
		$.[poll.poll_id][id]
		$.[poll.title][]
		$.[poll.body][]
		$.[poll.dt][]
		$.[poll.dt_finish][]
		$.[poll.result][]
		$.[IF(dt_finish > NOW(), 1, 0)][status]
	]
	$.t(1)
]]
$crdPoll.table[^mFilter[$crdPoll.table]]
<atable label="Mouse CMS | Голосования ">
	^crdPoll.draw[
		$.names[^table::create{name	id	object
ID	id
Название	title
Дата публикации	dt
Дата окончания	dt_finish
Статус	status
}]]
	^added[]
^form_engine[
	^$.where[poll_id]
	^$.action[delete]
	^$.tables[^$.main[poll]]
]
^crdPoll.scroller[$.uri[$SYSTEM.path]]
</atable>
}