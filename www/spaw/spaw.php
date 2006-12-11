<html>
    <head>
        <title>Mouse</title>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1251" />
    </head>
    <body>
<form>
<?php
$GLOBALS['spaw_root'] = $spaw_root = $GLOBALS['PTH']['spaw'];
require_once $GLOBALS['PTH']['spaw'] . 'spaw_control.class.php';

$WYSIWYG = new SPAW_Wysiwyg('editor', '',
                       'en', 'full', 'default',
                       '100%', '100%');
$WYSIWYG->show();
$name = $_GET['name'];
echo
<<<HTML
<script language="JavaScript" type="text/javascript">
es = window.opener.document.getElementsByName('$name');
e = document.getElementById('editor_rEdit');
document.getElementById('editor').value = es[0].value;
//e.contentDocument.body.innerHTML = es[0].value;
function SPAW_apply_click()
{
    es[0].disabled = false;
    if (e.contentDocument) {
        es[0].value = e.contentDocument.body.innerHTML;
    } else {
        es[0].value = document.frames[0].document.body.innerHTML;
    }
    
    window.opener.focus();
    window.close();
}
</script>
HTML;
?>
</form>
</body>
</html>