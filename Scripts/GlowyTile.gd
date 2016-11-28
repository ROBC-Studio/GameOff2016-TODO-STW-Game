
extends Node

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	var animationPlayer = get_node("./AnimationPlayer");
	animationPlayer.play("glow");
	return;
