
extends Node

onready var _id = get_parent().get_parent().register(get_path());

# expects props: id and isDead
var _state = {};

var _intialized = false;

func setState(state): 
	# TODO Optimize for noop?
	if (!_intialized):
		for entity in state:
			if (entity.id == _id && _state != entity):
				_state = entity;
				_intialized = true;
				print("State set:");
				print(_state);
				return;
		# if you didn't find yourself... uhhh
		# TODO: Need to show better error
		printerr("Unable to find my state %d" % _id);
	return;


func getState():
	return _state;
	
func isDead():
	return _state.isDead;



