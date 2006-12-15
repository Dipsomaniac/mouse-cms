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
@init[hParams]
# определение значений по умолчанию
$hObject[
	$.oSql[$MAIN:objSQL]
	$.order[sort_order]
]]
# проверка заданных параметров
^if(!def $hParams.table){^throw[curd;Initialization failure. ^$.table option MUST be specified.]}
# получение параметров
^hObject.add[$hParams]
# создание таблицы
$table[^mGetSql[$hObject]]
# создание хэша (с ключом $.table(1) не создается)
^if(!^hObject.table.int(0)){$hash[^table.hash[id]]}
# получение структуры =debug
# $hObject.structure[^hObject.oSql.sql[table][SHOW COLUMNS FROM $hObject.table][][$.file[${hObject.table}_struct.cache]]]
#end @init[hParams]



####################################################################################################
# метод формирующий и выполняющий sql запрос
@mGetSql[hParams]
$result[
	^hObject.oSql.sql[table][
		SELECT
			^hParams.names.foreach[key;value]{$key ^if(def $value){ AS $value }}[,]
		FROM
			$hParams.table
		^if(def $hParams.leftjoin){ LEFT JOIN $hParams.leftjoin USING ($hParams.using) }
		^if(def $hParams.where){ WHERE $hParams.where }
		^if(def $hParams.group){GROUP BY $hParams.group }
		^if(def $hParams.order){ORDER BY $hParams.order }
		^if(def $hParams.having){HAVING $hParams.having }
	][
		^if(def $hParams.limit){$.limit($hParams.limit)}
		^if(def $hParams.offset){$.offset($hParams.offset)}
	][$.file[${hParams.table}_^math:md5[${hParams.where}${hParams.order}${hParams.leftjoin}${hParams.using}].cache]]
]
#end @getSql[hParams]



####################################################################################################
# метод выводящий простенький список данных
@list[hParams][hList]
$hList[$.tag[field_option]$.id[id]$.value[name]]
^hList.add[$hParams]
$result[^table.menu{<$hList.tag id="$table.[$hList.id]" value="$table.[$hList.value]" $hList.added />}]
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
^if($hTable.scroller){^hTable.add[^scroller[$table]]}
# построение шапки таблицы
^hTable.names.menu{<${hTable.tag}_th id="$hTable.names.id">$hTable.names.name</${hTable.tag}_th>}
# построение строк
^hTable.table.menu{
<${hTable.tag}_tr id="$hTable.table.id">
^untaint[as-is]{$hTable.code}
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
