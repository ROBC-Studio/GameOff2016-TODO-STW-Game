
extends Node

onready var Store = get_node("/root/Store");
onready var _name = get_name();

var _state = {};
var _currentId = 0;

func _ready():
	add_to_group("store_listener");
	

func onUpdate(newState):
	# We only care about the state relevant to ourselves, defined by get_name()
	var myState = newState[_name];
	
	# set the state if it has not been set already
	if (_state != myState):
		_state = myState;
		print("State has been set for: %s" % _name);
	
	# pass state down to children
	for child in get_children():
		# This is mostly to handle the case that there may be new children that don't have their 
		# segment of state set yet. Also to clean up children that do not belong in state anymore
		child.find_node("Entity").setState(_state);
		# clean up dead children... morbid I know
		if (child.find_node("Entity").isDead()):
			_state.erase(child.getState());

# returns an integer which is the new id for the regeristing object
func register():
	var id = _currentId;
	_currentId = _currentId + 1;
	get_node("/root/Store").add_entity_to_store({
		isDead = false,
		id = id
	}, get_name());
	return id;