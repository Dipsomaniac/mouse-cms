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
$hObject[^hash::create[]]
$hObject.oSql[$MAIN:objSQL]
$hObject.order[sort_order]
# проверка заданных параметров
^if(!def $hParams.table){^throw[curd;Initialization failure. ^$.table option MUST be specified.]}
# получение параметров
^hObject.add[$hParams]
# получение структуры =debug
$hObject.structure[^hObject.oSql.sql[table][SHOW COLUMNS FROM $hObject.table][][$.file[${hObject.table}_struct.cache]]]
# создание объектов (таблица, хэш)
$table[^mGetSql[$hObject]]
$hash[^table.hash[id]]
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
# метод выводящий список данных
@list[hParams][hList]
$hList[^hash::create[]]
$hList.tag[list]
$hList.tags[lists]
^hList.add[$hParams]
<$hList.tags label="$hList.label">
^table.menu{
	<$hList.tag
		^hList.names.menu{
			$hList.names.id = "^if(def $hList.names.object){$hList.[${hList.names.object}].[${table.[$hList.names.id]}].name}{$table.[$hList.names.id]}"
		}[ ]
	/>
}
</$hList.tags>
#end @list[hParams]