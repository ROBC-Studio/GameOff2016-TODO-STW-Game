
extends Node

var _currentChildIndex = 0;

func tick():
	if (_currentChildIndex < get_child_count()):
		var state = get_children()[_currentChildIndex].tick();
		if (state == "SUCESS"):
			_currentChildIndex = _currentChildIndex + 1;
			return "RUNNING";
		elif (state == "FAILURE"):
			return "FAILURE";
		else:
			return "RUNNING";
	return "SUCCESS";

func close():
	_currentChildIndex = 0;


