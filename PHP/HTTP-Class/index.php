<?php
#==============================================================================
# Include HTTP class
#==============================================================================
require_once 'include/HTTP.php';

#==============================================================================
# Initialize HTTP class
#==============================================================================
HTTP::init();

#==============================================================================
# Check if GET parameters are set
#==============================================================================
if(HTTP::issetGET('parameter_one', 'parameter_two', 'parameter_three')) {
	$parameter_one = HTTP::GET('parameter_one');
	$parameter_two = HTTP::GET('parameter_two');

	var_dump($parameter_one, $parameter_two, HTTP::GET('parameter_three'));
}

#==============================================================================
# Check if POST parameters are set
#==============================================================================
if(HTTP::issetPOST('parameter_one', 'parameter_two', 'parameter_three')) {
	$parameter_one = HTTP::POST('parameter_one');
	$parameter_two = HTTP::POST('parameter_two');

	var_dump($parameter_one, $parameter_two, HTTP::POST('parameter_three'));
}

#==============================================================================
# Check if POST parameters in conjunction with a specific value are set
#==============================================================================
if(HTTP::issetPOST('parameter_one', 'parameter_two', ['parameter_three' => 'value_three'])) {
	// do something
}

#==============================================================================
# Check the HTTP request method
#==============================================================================
if(HTTP::requestMethod('GET') OR HTTP::requestMethod('POST') OR HTTP::requestMethod('HEAD')) {
	// do something
}

#==============================================================================
# Get the HTTP request method
#==============================================================================
$requestMethod = HTTP::requestMethod();

#==============================================================================
# Get the HTTP status code of the current request
#==============================================================================
$statusCode = HTTP::responseStatus();

#==============================================================================
# Send a HTTP status code to the client
#==============================================================================
HTTP::responseStatus(200);

#==============================================================================
# Send a custom HTTP response header to the client
#==============================================================================
HTTP::responseHeader(HTTP::HEADER_CONTENT_TYPE, HTTP::CONTENT_TYPE_TEXT);

#==============================================================================
# Send a HTTP redirect to the client and stop script execution
#==============================================================================
# HTTP::redirect('https://example.org/');
# HTTP::redirect('https://example.org/', 303);
?>