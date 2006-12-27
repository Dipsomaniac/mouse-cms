^CalendarRun[$lparams]



####################################################################################################
# обработка календаря
@CalendarRun[lparams][calendar]
$lparams.body
^rem{ *** получаем информацию о календаре и выводим его *** }
$calendar[^getCalendar[$.path[$SYSTEM.path]]]
<block_content>
<div>
	^printCalendar[$calendar]
</div>
</block_content>
#end @CalendarRun[lparams][calendar]



####################################################################################################
# вывод календаря
@printCalendar[calendar][now;curr_year;curr_month;y_hash;ym_hash;i;m]
^if($calendar){
	$now[^date::now[]]
	$curr_year(^form:year.int(^dtf:format[%Y]))
	$curr_month(^form:month.int(^dtf:format[%m]))

	$y_hash[^calendar.hash[year;year][$.distinct(1)]]
	$ym_hash[^calendar.hash{^calendar.year.format[%04d]=^calendar.month.format[%02d]}[month][$.distinct(1)]]
	$year[^y_hash._keys[]]
	^year.sort($year.key)[desc]
	<div id="year">
	^year.menu{
		<li>^if($year.key == $curr_year){
			$year.key 
		}{
			^rem{ *** если кликнем в год, по попадем на последний месяц года, 
				за который у нас есть новости *** }
			^if(^calendar.locate[year;$year.key]){}
			<a href="?year=$year.key&amp^;month=$calendar.month">$year.key</a>
		}
		</li>
	}
	</div>
	<div id="month">
	^if(^year.locate[key;$curr_year]){}
	^for[i](0;11){
		$m(12-$i)
		^if(def $form:month && $m == $curr_month){
			<li><b>$dtf:[ri-locale].month.$m</b></li>
		}{
			^if(!($now.year == $curr_year && $m > $now.month)){
				^if($ym_hash.[^curr_year.format[%04d]=^m.format[%02d]]){
					<li><a href="?year=$curr_year&amp^;month=$m">$dtf:[ri-locale].month.$m</a></li>
				}
			}
		}
	}
	</div>
}
#end @printCalendar[]


@getCalendar[lparams][params]
$params[^hash::create[$lparams]]
$result[^MAIN:objSQL.table{
	SELECT
		^MAIN:objSQL.month[dt] AS month,
		^MAIN:objSQL.year[dt] AS year
	FROM
		article
	LEFT JOIN
		article_type
	USING
		(article_type_id)
	WHERE
		article.is_published = 1 AND
		article.dt_published <= ^MAIN:objSQL.now[] AND
		article_type.path = '$params.path'
	GROUP BY
		year,
		month
}[][^if($MAIN:NoCache){}{$.file[articles_calendar.cache]}]]