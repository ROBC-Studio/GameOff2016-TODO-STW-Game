
extends Node

var state = { 
	isSet = false,
	runningNodes = [],
	currentNode = ""
};

func _ready():
	set_process(true);
	return;

func _process(delta):
	if (get_children().empty()):
		return;
		
	if (state.runningNodes.empty()): 
		for child in get_children():
			state.runningNodes.append(child.get_path());
			
	if (state.currentNode == ""):
		state.currentNode = state.runningNodes.pop_front();
	
	var st = get_node(state.currentNode).tick();
	
	if (st == "RUNNING"):
		return;
	if (!state.runningNodes.empty() and st == "SUCCESS" or st == "FAILURE"):
		state.currentNode = state.runningNodes.pop_back();
		return;



