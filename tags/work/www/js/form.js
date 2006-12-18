/*
required=1 - Required field. The red border will show if text field is empty or nothing is selected from drop down(select box)
mask = Some predefined masks are defined. At the moment, you can choose between, email, zip("NNNNN-NNNN") and numeric. 
freemask = A combination of string and digits. Example: freemask = "NNNN-SS" which means that there has to be 4 digits followed by a hyphen followed by two alphabetical characters(A-Z)
regexpPattern = A regular expression pattern. Example: regexpPattern="/\b[A-Z0-9.-]+\.[A-Z]{2,4}\b/gi" which is the pattern for an internet domain	
*/
var formValidationMasks = new Array();
formValidationMasks['email'] = /\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/gi;	// Email
formValidationMasks['numeric'] = /^[0-9]+$/gi;	// Numeric
formValidationMasks['zip'] = /^[0-9]{5}\-[0-9]{4}$/gi;	// Numeric

var formElementArray = new Array();

function validateInput(e,inputObj)
{
	if(!inputObj)inputObj = this;		
	var inputValidates = true;
	
	if(formElementArray[inputObj.name]['required'] && inputObj.tagName=='INPUT' && inputObj.value.length==0)inputValidates = false;
	if(formElementArray[inputObj.name]['required'] && inputObj.tagName=='SELECT' && inputObj.selectedIndex==0){
		inputValidates = false;
	}
	if(formElementArray[inputObj.name]['mask'] && !inputObj.value.match(formValidationMasks[formElementArray[inputObj.name]['mask']]))inputValidates = false;

	if(formElementArray[inputObj.name]['freemask']){
		var tmpMask = formElementArray[inputObj.name]['freemask'];
		tmpMask = tmpMask.replace(/-/g,'\\-');
		tmpMask = tmpMask.replace(/S/g,'[A-Z]');
		tmpMask = tmpMask.replace(/N/g,'[0-9]');
		tmpMask = eval("/^" + tmpMask + "$/gi");
		if(!inputObj.value.match(tmpMask))inputValidates = false
	}	
	
	if(formElementArray[inputObj.name]['regexpPattern']){
		var tmpMask = eval(formElementArray[inputObj.name]['regexpPattern']);
		if(!inputObj.value.match(tmpMask))inputValidates = false
	}
	if(!formElementArray[inputObj.name]['required'] && inputObj.value.length==0 && inputObj.tagName=='INPUT')inputValidates = true;
	
	
	if(inputValidates){
		inputObj.className='validInput';
	}else{
		inputObj.className='invalidInput'
	}
}

function isFormValid()
{
	var Fields = document.getElementsByTagName('INPUT');
	for(var no=0;no<Fields.length;no++){
		if(Fields[no].className=='invalidInput')return false;
	}
	var Fields = document.getElementsByTagName('SELECT');
	for(var no=0;no<Fields.length;no++){
		if(Fields[no].className=='invalidInput')return false;
	}
	return true;	
}




function initFormValidation()
{
	var inputFields = document.getElementsByTagName('INPUT');
	var selectBoxes = document.getElementsByTagName('SELECT');
	
	var inputs = new Array();
	
	
	for(var no=0;no<inputFields.length;no++){
		inputs[inputs.length] = inputFields[no];
		
	}	
	for(var no=0;no<selectBoxes.length;no++){
		inputs[inputs.length] = selectBoxes[no];
		
	}
	
	for(var no=0;no<inputs.length;no++){
		var required = inputs[no].getAttribute('required');
		if(!required)required = inputs[no].required;		
		
		var mask = inputs[no].getAttribute('mask');
		if(!mask)mask = inputs[no].mask;
		
		var freemask = inputs[no].getAttribute('freemask');
		if(!freemask)freemask = inputs[no].freemask;
		
		var regexpPattern = inputs[no].getAttribute('regexpPattern');
		if(!regexpPattern)regexpPattern = inputs[no].regexpPattern;
		
		inputs[no].className = 'invalidInput';
		
		inputs[no].onblur   = validateInput;
		inputs[no].onchange = validateInput;
		inputs[no].onpaste  = validateInput;
		inputs[no].onkeyup  = validateInput;
		
		
		formElementArray[inputs[no].name] = new Array();
		formElementArray[inputs[no].name]['mask'] = mask;
		formElementArray[inputs[no].name]['freemask'] = freemask;
		formElementArray[inputs[no].name]['required'] = required;
		formElementArray[inputs[no].name]['regexpPattern'] = regexpPattern;

		validateInput(false,inputs[no]);
			
	}	
}
window.onload = initFormValidation;