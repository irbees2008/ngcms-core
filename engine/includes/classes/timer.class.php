<?php

//
// Copyright (C) 2006-2008 Next Generation CMS (http://ngcms.ru/)
// Name: timer.class.php
// Description: Time measurer class
// Author: Vitaly Ponomarev, Alexey Zinchenko
//

class microTimer {

	// CONSTRUCTOR
	function microTimer(){
		$this->events = array();
	}

	function start() {
		list($usec, $sec) = explode(' ', microtime());
		$this->script_start = (float) $sec + (float) $usec;
		$this->last_event = $this->script_start;
	}

	function stop($points = 2) {
		list($usec, $sec) = explode(' ', microtime());
		$script_end = (float) $sec + (float) $usec;
		$elapsed_time = round($script_end - $this->script_start, $points);

		return $elapsed_time;
	}

	// CLEAR event list
	function clearEvents(){ $this->events = array(); }

	// REGISTER measurment
	function registerEvent($eventName, $eventParams = ''){
		$current_time = $this->stop(4);
		$delta = $current_time - $this->last_event;
		if ($delta < 0) $delta = 0;
		
		array_push($this->events, array( $current_time, sprintf('%7.3f', $delta), $eventName, $eventParams ));
		$this->last_event = $current_time;
	}

	// Return a list of events
	function returnEvents(){ return $this->events; }

	// Print events
	function printEvents($html = 0){
		$out = ($html)?"<table class='timeProfiler'>\n<tr><td><b>Time</b></td><td><b>Delta</b></td><td><b>Event</b></td><td><b>Desc</b></td></tr>\n":'';
		foreach ($this->events as $v) {
			$out .= ($html)?('<tr><td>'.$v[0].'</td><td>'.$v[1].'</td><td>'.$v[2].'</td><td>'.$v[3]."</td></tr>\n"):$v[0]."\t".$v[1]."\t".$v[2]."\t".$v[3]."\n";
		}
		$out .= (($html)?"</table>":'')."\n";
		return $out;
	}
}
