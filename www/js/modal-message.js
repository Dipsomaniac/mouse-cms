DHTML_modalMessage = function()
{
	var url;								// url of modal message
	var htmlOfModalMessage;					// html of modal message
	
	var divs_transparentDiv;				// Transparent div covering page content
	var divs_content;						// Modal message div.
	var layoutCss;							// Name of css file;
	var width;								// Width of message box
	var height;								// Height of message box
	
	var existingBodyOverFlowStyle;			// Existing body overflow css
	var dynContentObj;						// Reference to dynamic content object
	var cssClassOfMessageBox;				// Alternative css class of message box - in case you want a different appearance on one of them
	var shadowDivVisible;					// Shadow div visible ? 
	var shadowOffset; 						// X and Y offset of shadow(pixels from content box)
	
	this.url = '';							// Default url is blank
	this.htmlOfModalMessage = '';			// Default message is blank
	this.layoutCss = 'modal-message.css';	// Default CSS file
	this.height = 200;						// Default height of modal message
	this.width = 400;						// Default width of modal message
	this.cssClassOfMessageBox = false;		// Default alternative css class for the message box
	this.shadowDivVisible = true;			// Shadow div is visible by default
	this.shadowOffset = 5;					// Default shadow offset.
	
	

}

DHTML_modalMessage.prototype = {
	// {{{ setSource(urlOfSource)
    /**
     *	Set source of the modal dialog box
     * 	
     *
     * @public	
     */		
	setSource : function(urlOfSource)
	{
		this.url = urlOfSource;
		
	}	
	// }}}	
	,
	// {{{ setHtmlContent(newHtmlContent)
    /**
     *	Setting static HTML content for the modal dialog box.
     * 	
     *	@param String newHtmlContent = Static HTML content of box
     *
     * @public	
     */		
	setHtmlContent : function(newHtmlContent)
	{
		this.htmlOfModalMessage = newHtmlContent;
		
	}
	// }}}		
	,
	// {{{ setSize(width,height)
    /**
     *	Set the size of the modal dialog box
     * 	
     *	@param int width = width of box
     *	@param int height = height of box
     *
     * @public	
     */		
	setSize : function(width,height)
	{
		if(width)this.width = width;
		if(height)this.height = height;		
	}
	// }}}		
	,		
	// {{{ setCssClassMessageBox(newCssClass)
    /**
     *	Assign the message box to a new css class.(in case you wants a different appearance on one of them)
     * 	
     *	@param String newCssClass = Name of new css class (Pass false if you want to change back to default)
     *
     * @public	
     */		
	setCssClassMessageBox : function(newCssClass)
	{
		this.cssClassOfMessageBox = newCssClass;
		if(this.divs_content){
			if(this.cssClassOfMessageBox)
				this.divs_content.className=this.cssClassOfMessageBox;
			else
				this.divs_content.className='modalDialog_contentDiv';	
		}
					
	}
	// }}}		
	,	
	// {{{ setShadowOffset(newShadowOffset)
    /**
     *	Specify the size of shadow
     * 	
     *	@param Int newShadowOffset = Offset of shadow div(in pixels from message box - x and y)
     *
     * @public	
     */		
	setShadowOffset : function(newShadowOffset)
	{
		this.shadowOffset = newShadowOffset
					
	}
	// }}}		
	,	
	// {{{ display()
    /**
     *	Display the modal dialog box
     * 	
     *
     * @public	
     */		
	display : function()
	{
		if(!this.divs_transparentDiv){
			this.__createDivs();
		}	
		
		// Redisplaying divs
		this.divs_transparentDiv.style.display='block';
		this.divs_content.style.display='block';
		this.divs_shadow.style.display='block';		
			
		this.__resizeDivs();
		
		/* Call the __resizeDivs method twice in case the css file has changed. The first execution of this method may not catch these changes */
		window.refToThisModalBoxObj = this;		
		setTimeout('window.refToThisModalBoxObj.__resizeDivs()',150);
		
		this.__insertContent();	// Calling method which inserts content into the message div.
	}
	// }}}		
	,
	// {{{ ()
    /**
     *	Display the modal dialog box
     * 	
     *
     * @public	
     */		
	setShadowDivVisible : function(visible)
	{
		this.shadowDivVisible = visible;
	}
	// }}}	
	,
	// {{{ close()
    /**
     *	Close the modal dialog box
     * 	
     *
     * @public	
     */		
	close : function()
	{
		document.documentElement.style.overflow = '';	// Setting the CSS overflow attribute of the <html> tag back to default.
		/* Hiding divs */
		this.divs_transparentDiv.style.display='none';
		this.divs_content.style.display='none';
		this.divs_shadow.style.display='none';
		this.innerHTML='';
		
	}
	// }}}	
	,
	// {{{ __createDivs()
    /**
     *	Create the divs for the modal dialog box
     * 	
     *
     * @private	
     */		
	__createDivs : function()
	{
		// Creating transparent div
		this.divs_transparentDiv = document.createElement('DIV');
		this.divs_transparentDiv.className='modalDialog_transparentDivs';
		this.divs_transparentDiv.style.left = '0px';
		this.divs_transparentDiv.style.top = '0px';
		document.body.appendChild(this.divs_transparentDiv);
		// Creating content div
		this.divs_content = document.createElement('DIV');
		this.divs_content.className = 'modalDialog_contentDiv';
		this.divs_content.id = 'DHTMLSuite_modalBox_contentDiv';
		document.body.appendChild(this.divs_content);
		// Creating shadow div
		this.divs_shadow = document.createElement('DIV');
		this.divs_shadow.className = 'modalDialog_contentDiv_shadow';
		document.body.appendChild(this.divs_shadow);

	}
	// }}}	
	,
	// {{{ __resizeDivs()
    /**
     *	Resize the message divs
     * 	
     *
     * @private	
     */	
    __resizeDivs : function()
    {
    	
    	var topOffset = Math.max(document.body.scrollTop,document.documentElement.scrollTop);

		if(this.cssClassOfMessageBox)
			this.divs_content.className=this.cssClassOfMessageBox;
		else
			this.divs_content.className='modalDialog_contentDiv';	
			    	
    	if(!this.divs_transparentDiv)return;
    	
    	// Preserve scroll position
    	var st = Math.max(document.body.scrollTop,document.documentElement.scrollTop);
    	var sl = Math.max(document.body.scrollLeft,document.documentElement.scrollLeft);
    	document.documentElement.style.overflow = 'hidden';
    	window.scrollTo(sl,st);
    	setTimeout('window.scrollTo(' + sl + ',' + st + ');',10);
    	var bodyWidth = document.documentElement.clientWidth;
    	var bodyHeight = document.documentElement.clientHeight;
    	
		var bodyWidth, bodyHeight; 
		if (self.innerHeight){ // all except Explorer 
		 
		   bodyWidth = self.innerWidth; 
		   bodyHeight = self.innerHeight; 
		}  else if (document.documentElement && document.documentElement.clientHeight) {
		   // Explorer 6 Strict Mode 		 
		   bodyWidth = document.documentElement.clientWidth; 
		   bodyHeight = document.documentElement.clientHeight; 
		} else if (document.body) {// other Explorers 
		 
		   bodyWidth = document.body.clientWidth; 
		   bodyHeight = document.body.clientHeight; 
		} 

    	
    	// Setting width and height of content div
      	this.divs_content.style.width = this.width + 'px';
    	this.divs_content.style.height= this.height + 'px';  	
    	
    	// Creating temporary width variables since the actual width of the content div could be larger than this.width and this.height(i.e. padding and border)
    	var tmpWidth = this.divs_content.offsetWidth;	
    	var tmpHeight = this.divs_content.offsetHeight;
    	
    	
    	// Setting width and height of left transparent div
    	this.divs_transparentDiv.style.width = Math.ceil((bodyWidth - tmpWidth) / 2) + 'px';
    	this.divs_transparentDiv.style.height = bodyHeight + 'px';
    	
    	// Setting size extremely large for bottom, left and right side transparent divs.
    	this.divs_transparentDiv.style.height = '4000px';   
    	this.divs_transparentDiv.style.width = '4000px';   
    	
    	
		
    	this.divs_content.style.left = Math.ceil((bodyWidth - tmpWidth) / 2) + 'px';;
    	this.divs_content.style.top = (Math.ceil((bodyHeight - tmpHeight) / 2) +  topOffset) + 'px';
    	
 	
    	this.divs_shadow.style.left = (this.divs_content.style.left.replace('px','')/1 + this.shadowOffset) + 'px';
    	this.divs_shadow.style.top = (this.divs_content.style.top.replace('px','')/1 + this.shadowOffset) + 'px';
    	this.divs_shadow.style.height = tmpHeight + 'px';
    	this.divs_shadow.style.width = tmpWidth + 'px';
    	
    	
    	
    	if(!this.shadowDivVisible)this.divs_shadow.style.display='none';	// Hiding shadow if it has been disabled
    	
    	
    }	
	// }}}	
	,
	// {{{ __insertContent()
    /**
     *	Insert content into the content div
     * 	
     *
     * @private	
     */	
    __insertContent : function()
    {
		if(this.url){	// url specified - load content dynamically
//			ajax_loadContent('DHTMLSuite_modalBox_contentDiv',this.url);
			m_ajaxDo(this.url,'DHTMLSuite_modalBox_contentDiv');
		}else{	// no url set, put static content inside the message box
			this.divs_content.innerHTML = this.htmlOfModalMessage;	
		}
    }		
}

