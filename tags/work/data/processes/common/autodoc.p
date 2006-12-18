@CLASS
autodoc

####################################################################################################
# Вывод либо списка файлов/каталогов
# либо иерархии классов
# Вызывать где-нибудь внутри <body> ... </body>
@content[]
^if(def $form:view){
	$cookie:view[
		$.value[^form:view.int(0)]
		$.expires(365)]}
<table class="contentCells" style="width: 100%">
	<tr>
		<td style="width: 25%; vertical-align: top;">
		<h1>Показывать</h1>
		<form action="" method="post">
			<input type="radio" name="view" value="0" checked="checked" /> Список классов<br/>
			<input type="radio" name="view" value="1" ^if(^cookie:view.int(0)){checked="checked"} /> Иерархия классов<p/>
			<input type="submit" value="Изменить" />
		</form>
		^if(!^cookie:view.int(0)){
			^files[]
		}{
			^tree[]
		}
		</td>
		<td style="width: 75%; vertical-align: top;">
		^try{
			^classInfo[$form:path/$form:fileName]
		}{
			^if($exception.type eq file.access || $exception.type eq file.missing){$exception.handled(1)}
		}
		</td>
	</tr>
</table>



####################################################################################################
# Документация по классу
@classInfo[strClass][polyPageClass;tblPageClass;strPageClassName;strPageClassDescr;strBaseClass;nJx;tblClassMethod;strMethodDescr]
$polyPageClass[^file::load[text;$strClass]]
$polyPageClass[$polyPageClass.text]
$tblPageClass[^classNameAndDesc[$polyPageClass]]
# Имя класса
^if(def $tblPageClass.2){
	$strPageClassName[$tblPageClass.2]
}{
	$strPageClassName[MAIN]
}
# Описание класса
$strPageClassDescr[$tblPageClass.1]
# Родительский класс (если есть)
$strBaseClass[^baseClass[$polyPageClass]]
# замена шарпов на <br/>
$strPageClassDescr[^strPageClassDescr.match[#][g]{<br/>}]
$strPageClassDescr[^strPageClassDescr.match[<br/>][]{}]
# Вывод
<h1>Класс: $strPageClassName</h1>
^if(def $strBaseClass){
	$hashClasses[^classesHash[]]
	<h2>Родительский класс:</h2>
	<a href="./?path=$hashClasses.[$strBaseClass].path&amp^;fileName=$hashClasses.[$strBaseClass].file">
	$strBaseClass
	</a>
}
^if(def $strPageClassDescr){
	<dl>
		<dt><h2>Описание:</h2></dt>
		<dd>$strPageClassDescr</dd>
	</dl>
}
<h2><a name="methods" id="0">Методы (коротко):</a></h2>
$tblClassMethod[^methods[$polyPageClass]]
# Список со ссылками на подробное описание метода
<ol>
	$nJx(1)
	^tblClassMethod.menu{
		<li><a href="$request:uri#$nJx">$tblClassMethod.2</a></li>
		^nJx.inc(1)
	}
</ol>
<h2>Методы (подробно):</h2>
<dl>
	$nJx(1)
	^tblClassMethod.menu{
		<dt>
			<h3>
			${nJx}. <a name="$tblClassMethod.2" id="$nJx">$tblClassMethod.2</a> 
			[<a href="$request:uri#0">К началу</a>]
			</h3>
		</dt>
		^nJx.inc(1)
		<dd>
		<dl>
		$strMethodDescr[$tblClassMethod.1]
		$strMethodDescr[^strMethodDescr.match[#][g]{<br/>}]
		$strMethodDescr[^strMethodDescr.match[<br/>][]{}]
		^rem{/** Вывод описания метода (если есть) */}
		^if(^strMethodDescr.length[] > 2){
			<dt><h4>Описание:</h4></dt>
			<dd>$strMethodDescr</dd>
		}
		^rem{/** Вывод списка передаваемых параметров (если есть) */}
		^if(def $tblClassMethod.3){
			$tblParams[^tblClassMethod.3.split[^;]]
			<dt><h4>Параметры:</h4></dt>
			<dd>
			$nIx(1)
			^tblParams.menu{
				${nIx}. $tblParams.piece<br/>
				^nIx.inc(1)
			}
			</dd>
		}
		^rem{/** Вывод списка локальных переменных (если есть) */}
		^if(def $tblClassMethod.4){
			$tblLocalVars[^tblClassMethod.4.split[^;]]
			<dt><h4>Локальные переменные:</h4></dt>
			<dd>
#			$hashLocalVars[^tblLocalVars.hash[piece]]
			^tblLocalVars.menu{
				- $tblLocalVars.piece<br/>
			}
			</dd>
		}
		</dl>
		</dd>
	}
</dl>



####################################################################################################
# Файлы и каталоги с классами
@files[][tblFilesList]
<h1>Каталоги</h1>
<ul>
	<li>
	^if(def $form:path){
		<a href="?path=">Корень сайта</a>
	}{
		<strong>Корень сайта</strong>
	}
	</li>
	^MAIN:CLASS_PATH.menu{
		<li>
			^if($MAIN:CLASS_PATH.path ne $form:path){
				<a href="?path=$MAIN:CLASS_PATH.path">
				$MAIN:CLASS_PATH.path
				</a>
			}{
				<strong>$MAIN:CLASS_PATH.path</strong>
			}
		</li>
	}
</ul>
<h1>Файлы</h1>
$tblFilesList[^file:list[$form:path/;\.(p|html)^$]]
<ul>
	^tblFilesList.menu{
		<li>
			^if($tblFilesList.name ne $form:fileName){
				<a href="?path=$form:path&amp^;fileName=$tblFilesList.name">
				$tblFilesList.name
				</a>
			}{
				<strong>$tblFilesList.name</strong>
			}
		</li>
	}
</ul>



####################################################################################################
# таблица всех пользовательских классов сайта
@classesTable[][tblFilesList;polyPageClass;tblClassInfo]
$result[^table::create{class	file	path	base
MAIN	index.html	/	}]
^MAIN:CLASS_PATH.menu{
	$tblFilesList[^file:list[$MAIN:CLASS_PATH.path/;\.(p|html)^$]]
	^tblFilesList.menu{
		$polyPageClass[^file::load[text;$MAIN:CLASS_PATH.path/$tblFilesList.name]]
		$polyPageClass[$polyPageClass.text]
		^rem{/** Определение имени класса  */}
		$tblClassInfo[^classNameAndDesc[$polyPageClass]]
		^if(def $tblClassInfo.2){
			^result.append{$tblClassInfo.2	$tblFilesList.name	$MAIN:CLASS_PATH.path	^baseClass[$polyPageClass]}
		}
	}
}



####################################################################################################
# Хэш всех пользовательских классов сайта
@classesHash[]
$result[^classesTable[]]
$result[^result.hash[class]]



####################################################################################################
# Получает текст файла класса
# Возвращает таблицу с информацией о всех методах
# определённых в файле
#
# Раскладка по столбцам
# 1 - Описание метода
# 2 - Имя метода
# 3 - Строка передаваемых параметров (если есть) разделённых ;
# 4 - Строка локальных переменных (если есть) разделённых ;
@methods[strFileText]
$result[^strFileText.match[
	(?:
		\#{100} # метка начала описания метода (30 шарпов)
		([^^@]*?)? # описание метода
	)?
	(?:\n|^^) # перед @ обязательно или перевод строки или начало файла
			# ставить эту конструкцию именно тут - ВАЖНО!
	@([^^^$@^;()#]+?) # имя метода
	\[
		(.*?) # передаваемые параметры
	\]
	(?:
		\[
			(.*?) # локальные переменные
		\]
	)*
	\s
][gx]]



####################################################################################################
# Определение имени и описания класса (если есть)
# Получает текст файла класса
# Возвращает таблицу со столбцами:
# 1 - описание класса
# 2 - имя класса
@classNameAndDesc[strFileText]
$result[^strFileText.match[
	(?:
		\#{100}
		(.*?) # описание класса
	)?
	(?:\n|^^)
	@CLASS\n
	(.*?) # имя класса
	\n
][x]]



####################################################################################################
# Определение имени родительского класса (если есть)
# Получает текст файла класса
# Возвращает строку с именем базового класса
@baseClass[strFileText]
$result[^strFileText.match[
	\n
	@BASE
	\n
	(.+?) # имя базового класса
	\n
][x]]
$result[$result.1]



####################################################################################################
# формирование элемента дерева классов
@prnTreeItem[tblItem;strChilds]
$result[
	<li>
	^if($tblItem.file ne $form:fileName){
		<a href="?path=$tblItem.path&fileName=$tblItem.file" style="font-size: 90%">
		$tblItem.class
		</a>
	}{
		<strong>$tblItem.class</strong>
	}
	</li>
	<ul>$strChilds</ul>
]



####################################################################################################
# Хэш всех пользовательских классов сайта
# с ключом по род. классу
# Параметры:
# $tblItems - таблица с элементами дерева
# $strParent - столбец с идентификатором родителя
@createHashTree[tblItems;strParent][tblEmpty]
$tblEmpty[^table::create[$tblItems][$.limit(0)]]
$result[^hash::create[]]
^tblItems.menu{
	^if(!$result.[$tblItems.[$strParent]]){
		$result.[$tblItems.[$strParent]][^table::create[$tblEmpty]]
	}
	^result.[$tblItems.[$strParent]].join[$tblItems][$.limit(1)$.offset[cur]]
}



####################################################################################################
# Файлы и каталоги с классами
@tree[][tblClasses;hashTree]
$tblClasses[^classesTable[]]
^tblClasses.sort{class}
$hashTree[^createHashTree[$tblClasses;base]]
$result[
	<h1>Иерархия классов</h1>
	<ul>^prnTree[$hashTree;]</ul>
]



####################################################################################################
# формирование дерева элементов
# метод рекурсивно вызывает сам себя через вызов метода
# prnTreeItem(формирование элемента дерева)
# в $tblBrotherItems формируется список элементов одного уровня(с общим предком)
@prnTree[hashTree;strBase][tblBrotherItems]
^if($hashTree.[$strBase]){
	$tblBrotherItems[$hashTree.[$strBase]]
	^tblBrotherItems.menu{
		^prnTreeItem[$tblBrotherItems.fields;^if($hashTree.[$tblBrotherItems.class]){^prnTree[$hashTree;$tblBrotherItems.class]}]
	}
}
