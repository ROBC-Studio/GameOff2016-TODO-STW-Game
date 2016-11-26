
extends KinematicBody2D

onready var _vision = get_node("./RayCast2D");
onready var _body = self;
onready var _label = get_node("./KinematicBody2D/Label");
onready var _timer = get_node("/root/MyTimer");
var _canSeePlayer = false;
var elapsed = 0;
var motion = Vector2(0, 0);

func _ready():
	set_process(true);
	set_fixed_process(true);

func _process(delta):
	can_see_player();

func _fixed_process(delta):
	if (motion != Vector2(0, 0)):
		_body.move(motion.normalized()*40*delta);

func show_type():
	_label.set_text("GLITCH");
	
	_timer._wait(4);
	yield(_timer, "timer_end");
	
	_label.set_text("");
func wander(): 
	if (!_canSeePlayer):
		var x = rand_range(-1, 1);
		var y = rand_range(-1, 1);
		motion = Vector2(x, y);
		_timer._wait(10);
		yield(_timer, "timer_end");
		motion = Vector2(0, 0);
	
	
func can_see_player():
	if (_vision.is_colliding()):
		var getObj = _vision.get_collider();
		print(getObj.get_name());
		_canSeePlayer = true;
		motion = Vector2(0, 0);
	elif (_canSeePlayer):
		print("lost player");
		_canSeePlayer = false;
	
