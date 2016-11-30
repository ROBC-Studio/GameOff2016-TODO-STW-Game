
extends Node

func canExecute(npc, target):
	return true;

func execute(npc, target):
	var npcState = npc.get_node("./Entity").getState();
	var targetState = get_node(target).get_node("./Entity").getState();
	return;