<?php
#===============================================================================
# FUNCTION: Parser for timestamps [YYYY-MM-DD HH:II:SS]
#===============================================================================
function parseDatetime($datetime, $format) {
	list($datepart, $timepart)    = explode(' ', $datetime);
	list($year, $month, $day)     = explode('-', $datepart);
	list($hour, $minute, $second) = explode(':', $timepart);

	$months = [
		'01' => 'January',
		'02' => 'February',
		'03' => 'March',
		'04' => 'April',
		'05' => 'May',
		'06' => 'June',
		'07' => 'July',
		'08' => 'August',
		'09' => 'September',
		'10' => 'October',
		'11' => 'November',
		'12' => 'December'
	];

	$days = [
		0 => 'Sunday',
		1 => 'Monday',
		2 => 'Tuesday',
		3 => 'Wednesday',
		4 => 'Thursday',
		5 => 'Friday',
		6 => 'Saturday'
	];

	return strtr($format, [
		'[Y]' => $year,
		'[M]' => $month,
		'[D]' => $day,
		'[H]' => $hour,
		'[I]' => $minute,
		'[S]' => $second,
		'[W]' => $days[date('w', strtotime($datetime))],
		'[F]' => $months[date('m', strtotime($datetime))]
	]);
}

#===============================================================================
# EXAMPLE:
#===============================================================================
echo parseDatetime('2015-10-25 12:24:32', '[W], [D]. [F] [Y] at [H]:[M]');
?>