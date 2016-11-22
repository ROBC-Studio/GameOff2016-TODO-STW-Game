
extends Node

onready var _label = get_node("Label");
onready var _timer = get_node("/root/MyTimer");

func _ready():
	var sprite = get_node("AnimatedSprite");
	sprite.get_sprite_frames().set_animation_speed("default", 8.0);

func show_type():
	_label.set_text("GLITCH");
	
	_timer._wait(4);
	yield(_timer, "timer_end");
	
	_label.set_text("");