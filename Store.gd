
extends Node
# The store
# The goal is to receive actions on state and pass it on to the decider for state transactions

# Enemy actions:
const ADD_ENEMY = "ADD_ENEMY";
const REMOVE_ENEMY = "REMOVE_ENEMY";
const UPDATE_ENEMY = "UPDATE_ENEMY";

# Player actions:
const ADD_PLAYER = "ADD_PLAYER";
const AFFECT_PLAYER = "AFFECT_PLAYER";

var _state = {
	Enemies = [],
	Players = []
};

func dispatch(action):
	handleActions(_state, action);
	update();
	return;

func handleActions(state, action):
	if (action.type == REMOVE_ENEMY or action.type == UPDATE_ENEMY):
		handleEnemies(state.Enemies, action);
		return;
	if (action.type == AFFECT_PLAYER):
		handlePlayer(state.Players, action);
		return

func handleEnemies(state, action):
	if (action.type == ADD_ENEMY):
		state.append({ name = "new enemy"});
		
	return;
	
func handlePlayer(state, action):
	if (action.type == AFFECT_PLAYER):
		for entity in state:
			if (entity.id == action.id):
				entity["affected"] = true;
	return;

func add_entity_to_store(entity, storeName):
	_state[storeName].append(entity);

func update():
		get_tree().call_group(0, "store_listener", "onUpdate", _state);
		
func save_state():
	pass
