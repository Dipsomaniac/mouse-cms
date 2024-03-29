<?php 
// ================================================
// SPAW PHP WYSIWYG editor control
// ================================================
// Language class
// ================================================
// Developed: Alan Mendelevich, alan@solmetra.lt
// Copyright: Solmetra (c)2003 All rights reserved.
// ------------------------------------------------
//                                www.solmetra.com
// ================================================
// v.1.0, 2003-03-20
// ================================================

class SPAW_Lang
{
  // current language
  var $lang;
  // accessors
  function setLang($value)
  {
    $this->lang = $value;
  }
  function getLang()
  {
    $this->lang = $value;
  }

  // variable to hold current language block
  var $block;
  // accessors
  function setBlock($value)
  {
    $this->block = $value;
  }
  function getBlock()
  {
    return $this->block;
  }
  
  // charset for the current language
  var $charset;
  // accessors
  function getCharset()
  {
    return $this->charset;
  }

  // text direction for the current language
  var $dir = 'ltr';
  // accessors
  function getDir()
  {
    return $this->dir;
  }
  
  // language data
  var $lang_data;
  // default language data
  var $default_lang_data;
  
  // constructor
  function SPAW_Lang($lang = '')
  {
    global $spaw_default_lang;
    if ($lang == '')
    {
      $this->lang = $spaw_default_lang;
    }
    else
    {
      $this->lang = $lang;
    }
    $this->loadData();
  }

  // load language data
  function loadData()
  {
    require $GLOBALS['spaw_root'] . 'lib/lang/' . $this->lang . '/' . $this->lang . '_lang_data.inc.php';
    $this->charset = $GLOBALS['spaw_lang_charset'];
    
    if (!empty($GLOBALS['spaw_lang_direction'])) {
        $this->dir = $GLOBALS['spaw_lang_direction'];
    }
    $this->lang_data = $GLOBALS['spaw_lang_data'];
    unset($GLOBALS['spaw_lang_data']);
    
    require $GLOBALS['spaw_root'] . 'lib/lang/' . $GLOBALS['spaw_default_lang'] . '/' . $GLOBALS['spaw_default_lang'].'_lang_data.inc.php';
    $this->default_lang_data = $GLOBALS['spaw_lang_data'];
  }

  // return message
  function showMessage($message, $block='')
  {
    $_block = ($block == '')?$this->block:$block;
    if (!empty($this->lang_data[$_block][$message]))
    {
      // return message
      return $this->lang_data[$_block][$message];
    }
    else
    {
      // if message is not present in current language data 
      // return message from default language
      return (isset($this->default_lang_data[$_block][$message])?$this->default_lang_data[$_block][$message]:'');
    }
  }
  
  // shortcut for showMessage
  function m($message, $block='')
  {
    return $this->showMessage($message, $block);
  }
  
  // sets the root point for the data
  function setRoot($block = '')
  {
    // if no block passed -> reload data
    if ($block == '')
    {
      $this->loadData();
    }
    else
    {
      // "move pointer"
      $this->lang_data = $this->lang_data[$block];
      $this->default_lang_data = $this->default_lang_data[$block];
    }
  }
} // SPAW_Lang
?>