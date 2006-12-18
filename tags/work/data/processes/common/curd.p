#################################################################################################
# класс создает объекты таблицы БД, выводит списки, деревья и формы для их редактирования, обрабатывает запросы форм
# параметры:
# $.oSql			Объект SQL мишиного класса
# $.oAuth			Объект Auth мишиного класса
# $.table			Имя таблицы БД
# ....
@CLASS
curd



#################################################################################################
# Инициализация класса
@init[hParams][hObject]
# определение значений по умолчанию
$hObject[
	$.oSql[$MAIN:objSQL]
	$.order[sort_order]
]]
# проверка заданных параметров
^if(!def $hParams.name){^throw[curd;Initialization failure. ^$.name option MUST be specified.]}
# получение параметров
^hObject.add[$hParams]
# создание таблицы и хэша
$hObject.tab[^mGetSql[$hObject;$hObject.oSql]]
^if(^hObject.t.int(0) || !def $hObject.h){$table[$hObject.tab]}
^if(^hObject.h.int(0) || !def $hObject.t){
#	^if($hObject.name ne 'object'){^stop[hash $hObject.h table $hObject.t name $hObject.name]}
	$hash[^hObject.tab.hash[id]]}
# получение структуры =debug
# $hObject.structure[^hObject.oSql.sql[table][SHOW COLUMNS FROM $hObject.table][][$.file[${hObject.table}_struct.cache]]]
#end @init[hParams][hObject]



####################################################################################################
# метод формирующий и выполняющий sql запрос
@mGetSql[hParams;oSql][sRequest]
$sRequest[
	SELECT
		^untaint[as-is]{^hParams.names.foreach[key;value]{$key ^if(def $value){ AS $value }}[,]}
	FROM
		$hParams.name
		^if(def $hParams.leftjoin){ LEFT JOIN $hParams.leftjoin USING ($hParams.using) }
		^if(def $hParams.where){ WHERE $hParams.where }
		^if(def $hParams.group){GROUP BY $hParams.group }
		^if(def $hParams.order){ORDER BY $hParams.order }
		^if(def $hParams.having){HAVING $hParams.having }		
]
$result[
	^oSql.sql[table][$sRequest][$.limit($hParams.limit)$.offset($hParams.offset)][$.file[${hParams.name}_^math:md5[${sRequest}${hParams.limit}${hParams.offset}].cache]]
]
#end @getSql[hParams]



####################################################################################################
# метод выводящий простенький список данных
@list[hParams][hList]
$hList[$.tag[field_option]$.id[id]$.value[name]]
^hList.add[$hParams]
$result[^table.menu{<$hList.tag ${hList.id}="$table.[$hList.id]" ${hList.value}="$table.[$hList.value]" $hList.added />}]
#end @list[hParams][hList]



####################################################################################################
# скроллер
@scroller[tTable;hParams][hScroller;oScroller]
$hScroller[
		$.path_param[page]
		$.request[]
		$.table_count(^tTable.count[])
		$.number_per_section(^form:number.int(20))
		$.section_per_page(5)
		$.type[page]
		$.r_selector[ next ]
		$.l_selector[ prev ]
		$.divider[ ]
		$.r_divider[^]]
		$.l_divider[^[]
]
^hScroller.add[$hParams]
$oScroller[^scroller::create[$hScroller]]
$result[
	$.table[^table::create[$tTable;$.limit($oScroller.limit) $.offset($oScroller.offset)]]
	$.scroller[^oScroller.optimize[^oScroller.draw[]]]
	$.count[$hScroller.table_count]
	$.limit($oScroller.limit)
	$.offset($oScroller.offset)
]
#end @scroller[tTable;hParams][hScroller;oScroller]


####################################################################################################
# метод выводящий таблицу данных
@draw[hParams][hTable]
$hTable[$.tag[arow]$.scroller(1)]
^hTable.add[$hParams]
# обрезание таблицы скроллером при необходимости
^if($hTable.scroller){^hTable.add[^scroller[$table]]}{$hTable[$table]}
# построение шапки таблицы
^hTable.names.menu{<${hTable.tag}_th id="$hTable.names.id">$hTable.names.name</${hTable.tag}_th>}
# построение строк
^hTable.table.menu{
<${hTable.tag}_tr id="$hTable.table.id">
^process{@code[hFields]^#OA$hTable.code}
^code[$hTable.table.fields]
#	перебор колонок
	^hTable.names.menu{
		<${hTable.tag}_td
			id="$hTable.names.id"
			value="$hTable.table.[$hTable.names.id]"
			^if(def $hTable.names.object){name="^process[$caller.self]{^$${hTable.names.object}.${hTable.table.[$hTable.names.id]}.name}"}
		 />
	}
</${hTable.tag}_tr>
}
^if(def $hTable.scroller){<${hTable.tag}_scroller count="$hTable.count" offset="$hTable.offset" limit="$hTable.limit" now="^hTable.offset.inc($hTable.limit)$hTable.offset">$hTable.scroller</${hTable.tag}_scroller>}
#end @draw[hParams][hTable]
