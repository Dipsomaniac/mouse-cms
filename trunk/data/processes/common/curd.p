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
# $hObject.structure[^hObject.oSql.sql[table][SHOW COLUMNS FROM $hObject.table][][$.file[${hObject.table}_struct.cache]]]
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
@list[hParams][hList;oScroller]
$hList[^hash::create[]]
$hList.tags[list]
$hList.tag[list]
^hList.add[$hParams]
# создание скролера при необходимости
^if($hList.scroller){
	$oScroller[^scroller::create[
		$.path_param[page]
		$.request[]
		$.table_count(^table.count[])
		$.number_per_section(^form:number.int(20))
		$.section_per_page(5)
		$.type[page]
		$.r_selector[ next ]
		$.l_selector[ prev ]
		$.divider[ ]
		$.r_divider[^]]
		$.l_divider[^[]
	]]
$table[^table::create[$table;$.limit($oScroller.limit) $.offset($oScroller.offset)]]
}

# построение списка
^if(!^hList.simple.int(0)){<$hList.tags label="$hList.label">}
# построение заголовков
^if(!^hList.simple.int(0)){^hList.names.menu{<${hList.tag}_th id="$hList.names.id">$hList.names.name</${hList.tag}_th>}}
# перебор строк

^table.menu{
	^if(!^hList.simple.int(0)){
		<${hList.tag}_tr id="$table.id">
		<${hList.tag}_code>^process{$hList.code}</${hList.tag}_code>}
#		перебор колонок
	^if(^hList.simple.int(0)){
		<${hList.tag} 
		^hList.names.menu{ 
			$hList.names.id="$table.[$hList.names.id]" 
			^if($hList.select eq $table.[$hList.names.id]){select="1"} 
		} />
	}{
		^hList.names.menu{
			<${hList.tag}_td
				id="$hList.names.id"
				value="^if(def $hList.names.object){$hList.[${hList.names.object}].[${table.[$hList.names.id]}].name}{$table.[$hList.names.id]}"
				name="$table.[$hList.names.id]"
			 />
		}
	}
^if(!^hList.simple.int(0)){</${hList.tag}_tr>}
}

# скроллер
^if($hList.scroller){
	<${hList.tag}_scroller 
		count="$oScroller.table_count" 
		offset="$oScroller.offset" 
		limit="$oScroller.limit"
		now="^oScroller.offset.inc($oScroller.limit)$oScroller.offset"
	>^oScroller.optimize[^oScroller.draw[]]</${hList.tag}_scroller>
}
^if(def $hList.added){$hList.added}
^if(!^hList.simple.int(0)){</$hList.tags>}
#end @list[hParams][hList;oScroller;tData]



####################################################################################################
# метод создающий форму для редактирования данных
@form[hParams][hForm]
# значения по умолчанию
$hForm[^hash::create[]]
$hForm.name[form_content]
$hForm.form_id[form_content]
$hForm.enctype[multipart/form-data]
^hForm.add[$hParams]
<form method="post" action="/ajax/go.html" name="$hForm.name" id="$hForm.form_id" enctype="$hForm.enctype" label="$hForm.label">
<tabs>
	<tab id="section-1" name="Основное">
	^hForm.fields.menu{
		<field type="$hForm.fields.type" name="$hForm.fields.name" label="$hForm.fields.label" description="$hForm.fields.description" class="$hForm.fields.class">
			^if(def $hForm.fields.default){$hForm.[$hForm.fields.default]}{$hash.[$hForm.id].[$hForm.fields.name]}
		</field>
	}
	</tab>
</tabs>
$hForm.added
</form>
#end @form[hParams]