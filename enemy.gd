
extends KinematicBody2D

onready var _label = get_node("Label");
onready var _timer = get_node("/root/MyTimer");

const MOVE_SPEED = 5;

func _ready():
	var sprite = get_node("AnimatedSprite");
	sprite.get_sprite_frames().set_animation_speed("default", 8.0);

func show_type():
	_label.set_text("GLITCH");
	
	_timer._wait(4);
	yield(_timer, "timer_end");
	
	_label.set_text("");

func move_randomly():
	randomize();
	var x = rand_range(-10.0, 10.0);
	var y = rand_range(-10.0, 10.0);
	var moveVector = Vector2(x, y).normalized()*MOVE_SPEED;
	print (moveVector);
	self.move(moveVector);