###########################################################################
# $Id: dtf.p,v 1.21 2005/10/20 17:26:14 misha Exp $
#
# �������� ������:
# @create[date;default]					�� ������/���� ������������ ������ ���� date
# @format[fmt;date;locale]				������� ���������� date, ��������� ��������� ������
# @last-day[date]						���������� ���� ���������� ��� ���������[��������] ������
# @from822[string]						������� ���� �� ���������� ������-���� � ������� RFC822
# @to822[date;timezone]					�������� ���� �� ������� TZ � ��������� TZ � ������� � � ���� ������ � ������� RFC822
# @setLocale[locale]					������ ����� �������� locale, ��������� ������
# @resetLocale[]						���������� locale � default
#
###########################################################################


@CLASS
dtf


###########################################################################
@auto[][tmp]
# russian locale
$rr-locale[
	$.month[
		$.1[������]
		$.2[�������]
		$.3[�����]
		$.4[������]
		$.5[���]
		$.6[����]
		$.7[����]
		$.8[�������]
		$.9[��������]
		$.10[�������]
		$.11[������]
		$.12[�������]
	]
	$.weekday[
		$.0[�����������]
		$.1[������������]
		$.2[��������]
		$.3[�����]
		$.4[��������]
		$.5[�������]
		$.6[�������]
		$.7[�����������]
	]
]
$ri-locale[
	$.month[
		$.1[������]
		$.2[�������]
		$.3[����]
		$.4[������]
		$.5[���]
		$.6[����]
		$.7[����]
		$.8[������]
		$.9[��������]
		$.10[�������]
		$.11[������]
		$.12[�������]
	]
	$.weekday[
		$.0[�����������]
		$.1[�����������]
		$.2[�������]
		$.3[�����]
		$.4[�������]
		$.5[�������]
		$.6[�������]
		$.7[�����������]
	]
]
$rs-locale[
	$.month[
		$.1[���]
		$.2[���]
		$.3[���]
		$.4[���]
		$.5[���]
		$.6[���]
		$.7[���]
		$.8[���]
		$.9[���]
		$.10[���]
		$.11[���]
		$.12[���]
	]
	$.weekday[
		$.0[��]
		$.1[��]
		$.2[��]
		$.3[��]
		$.4[��]
		$.5[��]
		$.6[��]
		$.7[��]
	]
]
# english locale
$es-locale[
	$.month[
		$.1[Jan]
		$.2[Feb]
		$.3[Mar]
		$.4[Apr]
		$.5[May]
		$.6[Jun]
		$.7[Jul]
		$.8[Aug]
		$.9[Sep]
		$.10[Oct]
		$.11[Nov]
		$.12[Dec]
	]
	$.weekday[
		$.0[Sun]
		$.1[Mon]
		$.2[Tue]
		$.3[Wed]
		$.4[Thu]
		$.5[Fri]
		$.6[Sat]
		$.7[Sun]
	]
]
$ei-locale[
	$.month[
		$.1[January]
		$.2[February]
		$.3[March]
		$.4[April]
		$.5[May]
		$.6[June]
		$.7[July]
		$.8[August]
		$.9[September]
		$.10[October]
		$.11[November]
		$.12[December]
	]
	$.weekday[
		$.0[Sunday]
		$.1[Monday]
		$.2[Tuesday]
		$.3[Wednesday]
		$.4[Tuesday]
		$.5[Friday]
		$.6[Saturday]
		$.7[Sunday]
	]
]
# ukrain locale
$us-locale[
	$.month[
		$.1[�i�]
		$.2[���]
		$.3[���]
		$.4[��i]
		$.5[���]
		$.6[���]
		$.7[���]
		$.8[���]
		$.9[���]
		$.10[���]
		$.11[���]
		$.12[���]
	]
	$.weekday[
		$.0[���]
		$.1[���]
		$.2[�i�]
		$.3[���]
		$.4[���]
		$.5[�'�]
		$.6[���]
		$.7[���]
	]
]
$ui-locale[
	$.month[
		$.1[�i����]
		$.2[�����]
		$.3[��������]
		$.4[��i����]
		$.5[�������]
		$.6[�������]
		$.7[������]
		$.8[�������]
		$.9[��������]
		$.10[�������]
		$.11[��������]
		$.12[�������]
	]
	$.weekday[
		$.0[���i��]
		$.1[�����i���]
		$.2[�i������]
		$.3[������]
		$.4[������]
		$.5[�'������]
		$.6[������]
		$.7[���i��]
	]
]

$tz[
	$.CST[CST6CDT]
	$.EST[EST5EDT]
	$.GMT[GMT0BST]
	$.MET[MET-1DST]
	$.MED[MET-2DST]
	$.MSK[MSK-3MSD]
	$.MSD[MSD-4MSK]
	$.MST[MST7MDT]
	$.PST[PST8PDT]
}]

$max_day[
	$.1(31)
	$.2(29)
	$.3(31)
	$.4(30)
	$.5(31)
	$.6(30)
	$.7(31)
	$.8(31)
	$.9(30)
	$.11(31)
	$.11(30)
	$.12(31)
]

$default[$ri-locale]

$yy[]
$mm[]
$dd[]

$tmp[^self.setLocale[$default]]
#end @auto[]



###########################################################################
# ��������� ������ � ���� %Y-%m-%d %H:%M:%S �� ������-���� ������ � ������������ ������ ���� date
# ����� � ��������� ���������� �������: 2001-02-13, 2001-02-13 15:55[:55], 20:30
# ���� ������� ������ �����, �� ����� ����������� ������� ����
# ������� �������������: ^dtf:parse[2001-02-13], ^dtf:parse[2001-02-13 15:55] ��� ^dtf:parse[15:55]
# ���� ������� ��� ���������� ��� ���� ����� �������� ������, �� ������������� ������� ����.
@create[date;default]
^try{
	^if(!def $date || ($date is "string" && ^date.length[] < 4)){
		^throw[dtf.create;Wrong date format]
	}
	^if($date is "date"){
		$result[^date::create($date)]
	}{
		$result[^date::create[$date]]
	}
}{
	$exception.handled(1)
	^if(def $default){
		$result[^self.create[$default]]
	}{
		$result[^date::now[]]
	}
}
#end @create[]




###########################################################################
# ������� ���������� � ���� string ��� date ���� ��������� ��������� ������
# format - ��������� ������ � ���� posix (������ ����� ���� �� posix/mysql)
# date - ����, ������� ����� �������, �� ��������� - ������� ����
# locale - ���� ����� - �� locale (�� ��������� ������������ ������� locale)
# ������������: ^dtf:format[%Y-%m-%d] ��� ^dtf:format[%Y-%m-%d;$date]
#	�������� ��� � ���: ^dtf:format[%Y-%m-%d;$date;$dtf:ui-locale]
# $date ������ ���� ��� ������, ��� � ���������� ���� date
@format[fmt;date;locale]
$date[^self.create[$date]]

^if(!def $locale){$locale[$self.locale]}

$result[^fmt.match[%(.)][g]{^switch[$match.1]{
	^case[%]{%}
	^case[n]{^#0A}
	^case[t]{^#09}

	^case[e]{$date.day}
	^case[d]{^date.day.format[%02d]}

	^case[c]{$date.month}
	^case[m]{^date.month.format[%02d]}
	^case[h;B]{$locale.month.[$date.month]}
	^case[b]{^locale.month.[$date.month].left(3)}

	^case[Y]{$date.year}
	^case[y]{^eval($date.year % 100)[%02d]}
	^case[j]{$date.yearday}

	^case[w]{$date.weekday}
	^case[A]{$locale.weekday.[$date.weekday]}
	^case[a]{^locale.weekday.[$date.weekday].left(3)}

	^case[D]{^date.month.format[%02d]/^date.day.format[%02d]/$date.year}
	^case[F]{$date.year/^date.month.format[%02d]/^date.day.format[%02d]}

	^case[H]{^date.hour.format[%02d]}
	^case[k]{$date.hour}
	^case[i;M]{^date.minute.format[%02d]}
	^case[S]{^date.second.format[%02d]}
	^case[s]{^date.unix-timestamp[]}

	^case[T]{^date.hour.format[%02d]:^date.minute.format[%02d]:^date.second.format[%02d]}
	^case[R]{^date.hour.format[%02d]:^date.minute.format[%02d]}
	^case[r]{^if($date.hour > 0 && $date.hour < 13){$date.hour}{^if($date.hour < 1){^eval($date.hour + 12)}{^eval($date.hour - 12)}}:^date.minute.format[%02d]:^date.second.format[%02d]}
	^case[p]{^if($date.hour > 11){PM}{AM}}
	^case[P]{^if($date.hour > 11){pm}{am}}
	
	^case[_]{$es-locale.weekday.[$date.weekday], ^date.day.format[%02d] $es-locale.month.[$date.month] $date.year ^date.hour.format[%02d]:^date.minute.format[%02d]:^date.second.format[%02d]}
}}]
#end @format[]



###########################################################################
# ���������� ���� ��������� ��� ������ ��������[�������] ����
@last-day[date][_date]
$_date[^self.create[$date]]
^_date.roll[month](+1)
$result[^date::create($_date.year;$_date.month;01)]
^result.roll[day](-1)
#end @last-day[]



###########################################################################
# ������ ����� �������� locale � ��� ���� ���������� ������ ��������, ������� ��������� (���� ��������� ������������)
@setLocale[locale]
$result[$self.locale]
^if(def $locale){
	$self.locale[$locale]
	^self._init[]
}
#end @setLocale[]



###########################################################################
# ���������� locale � default
@resetLocale[]
$self.locale[$default]
#end @resetLocale[]



###########################################################################
# ��������� � ������-���� � ������� RFC822 � ������� �� �� ������ ���� date
# still under construction/testing.
@from822[string][_tmp;_fields;_name;_k;_v;_d2;_diff]
^try{
	^if(!def $string){
		^throw[dtf.from822;Empty date]
	}
	$_tmp[^string.match[(?:([a-z]{3}),\s+)?(\d{1,2})\s+([a-z]{3})\s+(\d{4}|\d{2})\s+(\d{1,2}):(\d{1,2}):(\d{1,2})\s+(\w{3,5})?(?:\s*([-+]?\d{1,2}(\d{2})?))?][i]]
	^if($_tmp){
		^if(^_tmp.1.match[\D]){
			$_fields[
				$.weekday_name[$_tmp.1]
				$.day($_tmp.2)
				$.month(0)
				$.month_name[$_tmp.3]
				$.year($_tmp.4)
				$.hour($_tmp.5)
				$.min($_tmp.6)
				$.sec($_tmp.7)
				$.tz[$_tmp.8]
				$.offset_hour[$_tmp.9]
				$.offset_min[$_tmp.10]
			]
		}{
			$_fields[
				$.weekday_name[]
				$.day($_tmp.1)
				$.month(0)
				$.month_name[$_tmp.2]
				$.year($_tmp.3)
				$.hour($_tmp.4)
				$.min($_tmp.5)
				$.sec($_tmp.6)
				$.tz[$_tmp.7]
				$.offset_hour[$_tmp.8]
				$.offset_min[$_tmp.9]
			]
		}
		^rem{ *** check month abbr *** }
		$_name[^_fields.month_name.lower[]]
		^es-locale.month.foreach[_k;_v]{
			^if(^_v.lower[] eq $_name){
				$_fields.month($_k)
			}
		}
		^if(!$_fields.month){
			^throw[dtf.from822;Unknown month '$_fields.month_name']
		}

		^if(def $_fields.offset_hour && !def $_fields.tz){
			$_fields.tz[GMT]
		}
		
		$result[^date::create($_fields.year;$_fields.month;$_fields.day;$_fields.hour;$_fields.min;$_fields.sec)]

		^rem{ *** check weekday abbr *** }
		^if(def $_fields.weekday_name){
			^if(^_fields.weekday_name.lower[] ne ^es-locale.weekday.[$result.weekday].lower[]){
				^throw[dtf.from822;Incorrect day of week '$_fields.weekday_name' in RFC822 date (must be '$es-locale.weekday.[$result.weekday]')]
			}
		}
		
		^rem{ *** roll time to timezone *** }
		^if(def $tz.[$_fields.tz]){
			$_d2[^date::create($result)]
			^_d2.roll[TZ;$tz.[$_fields.tz]]
			$_diff(^date::create($_d2.year;$_d2.month;$_d2.day;$_d2.hour;$_d2.minute;$_d2.second) - $result)
			$result[^date::create($_d2 - $_diff)]
		}
		
		^rem{ *** apply timezone offset *** }
		^if(def $_fields.offset_hour){
			$result[^date::create($result - ($_fields.offset_hour + ^_fields.offset_min.int(0) / 60) / 24)]
		}
	}{
		^throw[dtf.from822;Wrong RFC822 date format]
	}
}{
	^if($exception.type ne "dtf.from822"){
		$exception.handled(1)
		^throw[dtf.from822;Can't create date (${_fields.year}-${_fields.month}-$_fields.day ${_fields.hour}:${_fields.min}:${_fields.sec}).]
	}
}
#end @from822[]



###########################################################################
# �������� ���� �� ������� TZ � ��������� TZ � ������� � � ���� ������ � ������� RFC822
@to822[date;timezone]
$_date[^create[$date]]
^if(!def $timezone){$timezone[GMT]}
^if(def $tz.$timezone){
	^_date.roll[TZ;$tz.$timezone]
}
$result[^self.format[%_ $timezone;^date::create($_date.year;$_date.month;$_date.day;$_date.hour;$_date.minute;$_date.second)]]
#end @to822[]



###########################################################################
# ���������� ������� ����� ������ (number) - ��� �������� (name)
@_months[locale;is_lowercase][i]
^if(!def $locale){$locale[$self.locale]}
$result[^table::create{number	name
^for[i](1;12){$i	^if($is_lowercase){^locale.month.$i.lower[]}{$locale.month.$i}}[^#0A]}]
#end @_months[]



###########################################################################
# ������� ������� � ������ ����������� �� ������� locale
@_init[][i;_now]
$_now[^date::now[]]

$yy[^table::create{number	name
^for[i]($_now.year - 5;$_now.year + 5){$i	$i}[^#0A]}]

$dd[^table::create{number	name
^for[i](1;31){$i	^i.format{%02d}}[^#0A]}]

$mm[^self._months[]]
$mm-r[^self._months[$rr-locale]]
#end @_init[]



###########################################################################
###########################################################################

# ������ ����������� ���� ��� �������� �������������
@parse[date]
$result[^self.create[$date]]
#end @parse[]


@last-modifyed[date]
$result[^self.to822[$date]]
#end @last-modifyed[date]


