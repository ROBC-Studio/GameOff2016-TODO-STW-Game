
extends Node

export var setting = "flicker";

func _ready():
	get_node("./AnimationPlayer").play(setting);
	return;


