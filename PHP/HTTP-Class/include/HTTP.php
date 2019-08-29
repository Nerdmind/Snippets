<?php
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
# HTTP class                                                                   #
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
#                                                                              #
# Simple static class with more or less useful methods to simplify some checks #
# for the current HTTP request which was sent by the client.                   #
#                                                                              #
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#
class HTTP {
	private static $GET  = NULL;
	private static $POST = NULL;
	private static $FILE = NULL;

	#===============================================================================
	# HTTP protocol versions
	#===============================================================================
	const HTTP_VERSION_1_0 = 'HTTP/1.0';
	const HTTP_VERSION_1_1 = 'HTTP/1.1';
	const HTTP_VERSION_2_0 = 'HTTP/2.0';

	#===============================================================================
	# HTTP header fields
	#===============================================================================
	const HEADER_CONTENT_TYPE      = 'Content-Type';
	const HEADER_TRANSFER_ENCODING = 'Transfer-Encoding';
	const HEADER_ACCESS_CONTROL    = 'Access-Control-Allow-Origin';

	#===============================================================================
	# Values for HTTP header fields
	#===============================================================================
	const CONTENT_TYPE_JSCRIPT = 'application/x-javascript; charset=UTF-8';
	const CONTENT_TYPE_TEXT    = 'text/plain; charset=UTF-8';
	const CONTENT_TYPE_HTML    = 'text/html; charset=UTF-8';
	const CONTENT_TYPE_JSON    = 'application/json; charset=UTF-8';
	const CONTENT_TYPE_XML     = 'text/xml; charset=UTF-8';

	#===============================================================================
	# Initialize $GET, $POST and $FILE
	#===============================================================================
	public static function init($trimValues = TRUE) {
		self::$GET  = ($trimValues === TRUE ? self::trim($_GET)  : $_GET );
		self::$POST = ($trimValues === TRUE ? self::trim($_POST) : $_POST);
		self::$FILE = $_FILES;
	}

	#===============================================================================
	# Return a HTTP status code header description
	#===============================================================================
	private static function getStatuscode($code) {
		return [
			200 => 'OK',
			301 => 'Moved Permanently',
			302 => 'Found',
			303 => 'See Other',
			307 => 'Temporary Redirect',
			400 => 'Bad Request',
			401 => 'Authorization Required',
			403 => 'Forbidden',
			404 => 'Not Found',
			500 => 'Internal Server Error',
			503 => 'Service Temporarily Unavailable',
		][$code];
	}

	#===============================================================================
	# Trim all strings in argument
	#===============================================================================
	private static function trim($mixed) {
		if(is_array($mixed)) {
			return array_map('self::trim', $mixed);
		}

		return trim($mixed);
	}

	#===============================================================================
	# Check if all elements of $arguments are set as key of $data
	#===============================================================================
	private static function issetData($data, $arguments) {
		foreach($arguments as $key) {
			if(is_array($key)) {
				if(!isset($data[key($key)]) OR $data[key($key)] !== $key[key($key)]) {
					return FALSE;
				}
			}

			else if(!isset($data[$key]) OR !is_string($data[$key])) {
				return FALSE;
			}
		}

		return TRUE;
	}

	#===============================================================================
	# Return null or the value (if set) from one of the three requests attributes
	#===============================================================================
	public static function returnKey($data, Array $paths) {
		$current = &$data;

		foreach($paths as $path) {
			if(!isset($current[$path]) OR (!is_string($current[$path]) AND !is_array($current[$path]))) {
				return NULL;
			}
			$current = &$current[$path];
		}

		return $current;
	}

	#===============================================================================
	# Return GET value
	#===============================================================================
	public static function GET() {
		return self::returnKey(self::$GET, func_get_args());
	}

	#===============================================================================
	# Return POST value
	#===============================================================================
	public static function POST() {
		return self::returnKey(self::$POST, func_get_args());
	}

	#===============================================================================
	# Return FILE value
	#===============================================================================
	public static function FILE() {
		return self::returnKey(self::$FILE, func_get_args());
	}

	#===============================================================================
	# Check if all elements of func_get_args() are set key of self::$POST
	#===============================================================================
	public static function issetPOST() {
		return self::issetData(self::$POST, func_get_args());
	}

	#===============================================================================
	# Check if all elements of func_get_args() are set key of self::$GET
	#===============================================================================
	public static function issetGET() {
		return self::issetData(self::$GET, func_get_args());
	}

	#===============================================================================
	# Check if all elements of func_get_args() are set key of self::$FILE
	#===============================================================================
	public static function issetFILE() {
		return self::issetData(self::$FILE, func_get_args());
	}

	#===============================================================================
	# Return HTTP request method or check if request method equals with $method
	#===============================================================================
	public static function requestMethod($method = NULL) {
		if(!empty($method)) {
			return ($_SERVER['REQUEST_METHOD'] === $method);
		}

		return $_SERVER['REQUEST_METHOD'];
	}

	#===============================================================================
	# Return REQUEST_URI
	#===============================================================================
	public static function requestURI() {
		return $_SERVER['REQUEST_URI'] ?? FALSE;
	}

	#===============================================================================
	# Return HTTP_USER_AGENT
	#===============================================================================
	public static function useragent() {
		return trim($_SERVER['HTTP_USER_AGENT'] ?? '');
	}

	#===============================================================================
	# Return HTTP_REFERER
	#===============================================================================
	public static function referer() {
		return trim($_SERVER['HTTP_REFERER'] ?? '');
	}

	#===============================================================================
	# Return response status
	#===============================================================================
	public static function responseStatus($code = NULL) {
		if(!empty($code)) {
			self::sendHeader(sprintf('HTTP/1.1 %d %s', $code, self::getStatuscode($code)));
		}
		return http_response_code();
	}

	#===============================================================================
	# Send a HTTP header line to the client
	#===============================================================================
	public static function responseHeader($field, $value) {
		self::sendHeader("{$field}: {$value}");
	}

	#===============================================================================
	# Send a HTTP redirect to the client
	#===============================================================================
	public static function redirect($location, $code = 303, $exit = TRUE) {
		self::sendHeader(sprintf('HTTP/1.1 %d %s', $code, self::getStatuscode($code)));
		self::sendHeader("Location: {$location}");
		$exit AND exit();
	}

	#===============================================================================
	# Send a new HTTP header line to the client if headers are not already sent
	#===============================================================================
	private static function sendHeader($header) {
		if(!headers_sent()) {
			header($header);
		}
	}
}
?>