<?php 
// ================================================
// SPAW PHP WYSIWYG editor control
// ================================================
// Configuration file
// ================================================
// Developed: Alan Mendelevich, alan@solmetra.lt
// Copyright: Solmetra (c)2003 All rights reserved.
// ------------------------------------------------
//                                www.solmetra.com
// ================================================
// v.1.0, 2003-03-27
// ================================================

// directory where spaw files are located
if (!isset($GLOBALS['PTH']['main'])) {
   $GLOBALS['PTH']['main'] = '../';
}
//$GLOBALS['spaw_root'] = $GLOBALS['PTH']['main'].'spaw/';
$GLOBALS['spaw_root'] = 'y:/home/www.irokez.ru/www/spaw\\';

$GLOBALS['spaw_dir'] = '/spaw/';

// base url for images
$GLOBALS['spaw_base_url'] = 'http://www.irokez.ru';

$GLOBALS['spaw_default_toolbars'] = 'default';
$GLOBALS['spaw_default_theme'] = 'default';
$GLOBALS['spaw_default_lang'] = 'en';
$GLOBALS['spaw_default_css_stylesheet'] = $GLOBALS['spaw_dir'].'wysiwyg.css';

// add javascript inline or via separate file
$GLOBALS['spaw_inline_js'] = false;

// use active toolbar (reflecting current style) or static
$GLOBALS['spaw_active_toolbar'] = true;

// default dropdown content
$GLOBALS['spaw_dropdown_data']['style']['default'] = 'Normal';

$GLOBALS['spaw_dropdown_data']['table_style']['default'] = 'Normal';

$GLOBALS['spaw_dropdown_data']['td_style']['default'] = 'Normal';

$GLOBALS['spaw_dropdown_data']['font']['Arial'] = 'Arial';
$GLOBALS['spaw_dropdown_data']['font']['Courier'] = 'Courier';
$GLOBALS['spaw_dropdown_data']['font']['Tahoma'] = 'Tahoma';
$GLOBALS['spaw_dropdown_data']['font']['Times New Roman'] = 'Times';
$GLOBALS['spaw_dropdown_data']['font']['Verdana'] = 'Verdana';

$GLOBALS['spaw_dropdown_data']['fontsize']['1'] = '1';
$GLOBALS['spaw_dropdown_data']['fontsize']['2'] = '2';
$GLOBALS['spaw_dropdown_data']['fontsize']['3'] = '3';
$GLOBALS['spaw_dropdown_data']['fontsize']['4'] = '4';
$GLOBALS['spaw_dropdown_data']['fontsize']['5'] = '5';
$GLOBALS['spaw_dropdown_data']['fontsize']['6'] = '6';

// in mozilla it works only with this settings, if you don't care
// about mozilla you can change <H1> to Heading 1 etc.
// this way it will be reflected in active toolbar
$GLOBALS['spaw_dropdown_data']['paragraph']['Normal'] = 'Normal';
$GLOBALS['spaw_dropdown_data']['paragraph']['<H1>'] = 'Heading 1';
$GLOBALS['spaw_dropdown_data']['paragraph']['<H2>'] = 'Heading 2';
$GLOBALS['spaw_dropdown_data']['paragraph']['<H3>'] = 'Heading 3';
$GLOBALS['spaw_dropdown_data']['paragraph']['<H4>'] = 'Heading 4';
$GLOBALS['spaw_dropdown_data']['paragraph']['<H5>'] = 'Heading 5';
$GLOBALS['spaw_dropdown_data']['paragraph']['<H6>'] = 'Heading 6';

// image library related config

// allowed extentions for uploaded image files
$GLOBALS['spaw_valid_imgs'] = array('gif', 'jpg', 'jpeg', 'png');

// allow upload in image library
$GLOBALS['spaw_upload_allowed'] = true;

// allow delete in image library
$GLOBALS['spaw_img_delete_allowed'] = true;

// image libraries
$GLOBALS['spaw_imglibs'] = array(
array(
    'value'   => '../userfiles/articles/',
    'text'    => 'Article images',
  )
);
// file to include in img_library.php (useful for setting $GLOBALS['spaw_imglibs dynamically
// $GLOBALS['spaw_imglib_include = '';

// allowed hyperlink targets
$GLOBALS['spaw_a_targets']['_self'] = 'Self';
$GLOBALS['spaw_a_targets']['_blank'] = 'Blank';
$GLOBALS['spaw_a_targets']['_top'] = 'Top';
$GLOBALS['spaw_a_targets']['_parent'] = 'Parent';

// image popup script url
$GLOBALS['spaw_img_popup_url'] = $GLOBALS['spaw_dir'].'img_popup.php';

// internal link script url
$GLOBALS['spaw_internal_link_script'] = 'url to your internal link selection script';

// disables style related controls in dialogs when css class is selected
$GLOBALS['spaw_disable_style_controls'] = true;

?>