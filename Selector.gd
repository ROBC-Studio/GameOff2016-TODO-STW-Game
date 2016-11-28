
extends Node

var _currentChildIndex = 0;

func tick():
	print ("ticking select");
	if (_currentChildIndex < get_child_count()):
		var state = get_children()[_currentChildIndex].tick();
		if (state == "SUCESS"):
			return "SUCESS";
		elif (state == "FAILURE"):
			_currentChildIndex = _currentChildIndex + 1;
			return "RUNNING";
		else:
			return "RUNNING";
	# Ran out of children so this fails		
	return "FAILURE";

func close():
	_currentChildIndex = 0;
