
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

func tick():
	var node = get_node(get_tree().get_root().find_node("Entity").get_state().path);
	if (node.has_method("move_randomly")):
		node.move_randomly();
		return "SUCCESS";
	else:
		return "FAILURE";


