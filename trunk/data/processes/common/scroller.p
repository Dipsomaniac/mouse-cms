#################################################################################################
# $Id: scroller.p,v 2.0.4.0 2006/06/26 Eugene Spearance Exp $
#################################################################################################
@CLASS
scroller

#################################################################################################
# Конструктор @create[] задаёт основные параметры скроллера
#
# $scroller[^scroller::create[
#$.path_param[переменная_запроса]
#$.request[]
#$.table_count(число_записей_в_таблице)
#$.number_per_section[количество_элементов_секции]
#$.section_per_page[число_секций_на_странице]
#$.type[page/page_end/пусто]
#$.r_selector[правый_селектор_по_умолчанию_>>]
#$.l_selector[левый_селектор_по_умолчанию_<<]
#$.divider[разделитель_секций_по_умолчанию_пробел]
#$.r_divider[правый_разделитель_по_умолчанию_пусто]
#$.l_divider[левый_разделитель_по_умолчанию_пусто]
# ]
# ]
#
#################################################################################################

#################################################################################################
# Конструктор класса
@create[params][path_param;field;value]
^try{
^if(def $params && $params is "hash"){
^if(def $params.path_param){
$path_param[$params.path_param]
}{
^throw[scroller;path_param;^$.path_param must be defined]
}

^rem{* Проверяем значение количества записей в таблице *}
^if(def $params.table_count && ^params.table_count.int(0) > 0){
$table_count(^params.table_count.int(1))
}{
^throw[scroller;table_count;^$.table_count must be > 0]
}

^rem{* Возвращаем на место все поля формы *}
^if(def $params.request){
$path[$MAIN:sPath?^params.request.foreach[field;value]{^if($field ne $path_param){$field=^taint[uri][$value]&amp^;}}$path_param=]
}{
$path[$MAIN:sPath?^form:fields.foreach[field;value]{^if($field ne $path_param){$field=^taint[uri][$value]&amp^;}}$path_param=]
}

^rem{* Определяем тип скроллера page/page_end/пусто *}
$type[$params.type]

^rem{* Определяем сколько записей отображать *}
$number_per_section(^params.number_per_section.int(1))
^if($number_per_section < 1){$number_per_section(1)}

^rem{* Определяем текущее положение скроллера и делаем защиту от шаловливых рук *}
$record_number(^form:$path_param.int(1))
^if($record_number < 1){$record_number(1)}
^if($record_number > $table_count){$record_number($table_count)}

^rem{* Определяем количество секций на странице *}
^if(def $params.section_per_page){
$section_per_page(^params.section_per_page.int(1))
^if($section_per_page < 1){$section_per_page(1)}
}

$max_section(^math:ceiling($table_count / $number_per_section))

^rem{* Расчитываем сколько секций/страниц вывести на экран *}
^if($section_per_page){
^if($record_number < ($number_per_section * $section_per_page)){
$first_number(1)
}{
$first_number(($record_number \ $number_per_section - $section_per_page \ 2) * $number_per_section)
^if($number_per_section != 1){^first_number.inc[]}
}
$section($section_per_page)
}{
$first_number(1)
^if($number_per_section == 1){
$section($table_count)
}{
$section($max_section)
}
}

^rem{* Рассчитываем значение $first_number, от которого будут считаться ссылки секций/страниц  *}
^if(($number_per_section != 1 && $section_per_page || $section_per_page) && ^math:ceiling(($table_count-$first_number) / $number_per_section) < $section){
$first_number(($table_count - $number_per_section * ($section_per_page - 1)) \ $number_per_section * $number_per_section)
^if($number_per_section != 1){^first_number.inc[]}
^if($table_count % $number_per_section == 0 && $number_per_section != 1){^first_number.dec($number_per_section)}
}

^if($first_number < 1){$first_number(1)}
$second_number($first_number + $number_per_section - 1)

^rem{* Левый селектор (по-умолчанию <<) *}
^if(def $params.l_selector){$l_selector[$params.l_selector]}{$l_selector[&laquo^;]}

^rem{* Правый селектор (по-умолчанию >>) *}
^if(def $params.r_selector){$r_selector[$params.r_selector]}{$r_selector[&raquo^;]}

^rem{* Разделитель между номерами секций (по-умолчанию пробел) *}
^if(def $params.divider){$divider[$params.divider]}{$divider[ ]}

^rem{* Разделитель между правым селектором и секциями (по-умолчанию отсутствует) *}
^if(def $params.r_divider){$r_divider[<span class="scroller_rl_divider">$params.r_divider</span>]}{$r_divider[]}

^rem{* Разделитель между левым селектором и секциями (по-умолчанию отсутствует) *}
^if(def $params.l_divider){$l_divider[<span class="scroller_rl_divider">$params.l_divider</span>]}{$l_divider[]}
}{
^throw[scroller;create;parameters must be defined]
}
}{
$exception.handled(1)
$error(^_error_codes[$exception.source])
}
### End @create[]


#################################################################################################
@GET_limit[]
$result($number_per_section)
### End @GET_limit[]


#################################################################################################
@GET_offset[]
$result($record_number - 1)
### End @GET_offset[]


#################################################################################################
# выводит скроллер на экран
#####
@draw[][f1;text_link]
^if($error){
$error
}{
^rem{* Выводим левый селектор и левый разделитель если они есть *}
^if($first_number > 1){
^print_selector[^eval($first_number - $number_per_section);$l_selector]
$l_divider
}{
^if(!def $type){$l_divider}
}

^rem{* Основной цикл рисования скроллера *}
^for[f1](1;$section){
^if($first_number <= $table_count){
^if($number_per_section == 1){
$text_link($first_number)
}{
^switch[$type]{
^case[page;page_end]{$text_link(^math:ceiling($first_number / $number_per_section))}
^case[DEFAULT]{
^if($second_number > $table_count){
$text_link{
^if($first_number != $table_count){
${first_number}-$table_count
}{
$first_number
}
}
}{
$text_link[${first_number}-$second_number]
}
}
}
}
^print_link[$text_link]
}
^first_number.inc($number_per_section)
^second_number.inc($number_per_section)
}{
^rem{* Выводим разделитель между секциями *}
^if(($first_number - $number_per_section) <= $table_count){<span class="scroller_divider">$divider</span>}
}
^rem{* Выводим последнюю секцию если надо *}
^if($type eq "page_end" && $text_link < $max_section){
&hellip^;<a href="#" onClick="Go('${path}^eval($max_section * $number_per_section - $number_per_section + 1)','#container')" class="scroller_not_selected">$max_section</a>
}
^rem{* Выводим правый селектор и правый разделитель если они есть *}
^if(($second_number - $number_per_section) < $table_count){
$r_divider
^print_selector[^eval($second_number - $number_per_section + 1);$r_selector]
}{
^if(!def $type){$r_divider}
}
}
### End @draw[]


#################################################################################################
# делает ссылки активными/неактивными
#####
@print_link[text_link]
^if($record_number >= $first_number && $record_number <= $second_number){
$result[<span class="scroller_selected">[$text_link]</span>]
}{
$result[<a href="#" onClick="Go('${path}$first_number','#container')" class="scroller_not_selected">$text_link</a>]
}
### End @print_link[]


#################################################################################################
@print_selector[first_number;text_link]
$result[<a href="#" onClick="Go('${path}$first_number','#container')"  class="scroller_selector">$text_link</a>]
### End @scroller_selector[]


#################################################################################################
# 1 - не заданы параметры скроллера
# 2 - не определён $.path_param
# 3 - в таблице слишком мало записей
# 0 - ошибок в параметрах нет
@_error_codes[source]
^switch[$source]{
^case[create]{$result(1)}
^case[path_param]{$result(2)}
^case[table_count]{$result(3)}
^case[DEFAULT]{0}
}
### End @_error_codes[]


#################################################################################################
# убиваем лишние переводы строк и символы табуляции
#####
@optimize[text]
$result[^text.match[[\n\t]][g]{}]
### End @optimize[]