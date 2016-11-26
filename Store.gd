
extends Node
# The store
# The goal is to receive actions on state and pass it on to the decider for state transactions

# Enemy actions:
const LIST_ENEMIES = "LIST_ENEMIES";
const WANDER = "WANDER";

# Player actions:
const AFFECT_PLAYER = "AFFECT_PLAYER";

var _state = {
	Enemies = [],
	Players = []
};

# More specific code
# TODO Break out into multiple files?
func handleEnemies(state, action):
	if (action.type == LIST_ENEMIES):
		for entity in state:
			get_node(entity.path).show_type();
	if (action.type == WANDER):
		for entity in state:
			get_node(entity.path).wander();
		
	return;
	
func handlePlayer(state, action):
	if (action.type == AFFECT_PLAYER):
		for entity in state:
			if (entity.id == action.id):
				get_node(entity.path).affect_player();
				break;
	return;

func handleActions(state, action):
	if (action.type == LIST_ENEMIES or action.type == WANDER):
		handleEnemies(state.Enemies, action);
		return;
	if (action.type == AFFECT_PLAYER):
		handlePlayer(state.Players, action);
		return

# More general code:
func dispatch(action):
	handleActions(_state, action);
	update();
	return;
	
func add_entity_to_store(entity, storeName):
	_state[storeName].append(entity);
	return;

func update():
	get_tree().call_group(0, "store_listener", "onUpdate", _state);
	return;
		
func save_state():
	pass


