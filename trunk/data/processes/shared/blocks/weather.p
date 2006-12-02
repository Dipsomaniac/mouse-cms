^cache[../data/cache/weather.cache](36000){
^try{
		$sourceDoc[^xdoc::load[http://informer.gismeteo.ru/xml/23804_1.xml]] 
		<block_content>
		^sourceDoc.string[ 
    			$.method[html] 
		] 
		</block_content>
}{
	$exception.handled(1)
	<block_content>невозможно получить данные о погоде</block_content>
}
}