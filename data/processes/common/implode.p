#################################################################################################################
# $Id: implode.p,v 1.7 2002/12/03 18:07:44 misha Exp $
#################################################################################################################
# определение броузера

@detectBrowser[][ua;ver]
$ua[$env:HTTP_USER_AGENT]
^if(^ua.match[mac][i]){
	$MAIN:platform[mac]
}{
	^if(^ua.match[win][i]){
		$MAIN:platform[win]
	}{
		$MAIN:platform[unix]
	}
}

$ver[^ua.match[opera.(\d+)(\.(\d+))?][i]]
^if($ver){
	$MAIN:browser[opera]
	$MAIN:browser_ver(^ver.1.int(0))
	$MAIN:browser_subver(^ver.3.int(0))
}{
	$ver[^ua.match[msie.(\d+)(\.(\d+))?][i]]
	^if($ver){
		$MAIN:browser[ie]
		$MAIN:browser_ver(^ver.1.int(0))
		$MAIN:browser_subver(^ver.3.int(0))
	}{
		$ver[^ua.match[mozilla.(\d+)(\.(\d+))?][i]]
		^if($ver){
			$MAIN:browser[nn]
			$MAIN:browser_ver(^ver.1.int(0))
			$MAIN:browser_subver(^ver.3.int(0))
		}{
			$MAIN:browser[other]
			$MAIN:browser_ver(0)
			$MAIN:browser_subver(0)
		}
	}
}
$result[]
#end @detectBrowser[]

