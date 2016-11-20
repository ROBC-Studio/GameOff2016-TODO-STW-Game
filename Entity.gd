
extends Node

onready var _id = get_parent().get_parent().register();

# expects props: id and isDead
var _state = {};

var _intialized = false;

func setState(state): 
	if (!_intialized):
		for entity in state:
			if (entity.id == _id && _state != entity):
				_state = entity;
				_intialized = true;
				return;
		# if you didn't find yourself... uhhh
		printerr("Unable to find my state pops %d" % _id);


func getState():
	return _state;
	
func isDead():
	return _state.isDead;



