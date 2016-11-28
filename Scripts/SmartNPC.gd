
extends KinematicBody2D

onready var _vision = get_node("./RayCast2D");
onready var _label = get_node("./Label");
onready var _body = self;
onready var _timer = get_node("/root/MyTimer");
var _canSeePlayer = false;
var _player = null;
var _motion = Vector2(0, 0);
var _navigationPoints = [];

const VECTOR_RIGHT = Vector2(1, 0);
const VECTOR_LEFT = Vector2(-1, 0);
const VECTOR_UP = Vector2(0, 1);
const VECTOR_DOWN = Vector2(0, -1);
const VECTOR_STOP = Vector2(0, 0);

export var speed = 40;
export var visionDistance = 200;
export var isWatching = false;
export var debug = false;

# Publically accessible methods
func show_type():
	_label.set_text("GLITCH");
	_timer._wait(4);
	yield(_timer, "timer_end");	
	_label.set_text("");
	return;

# Wander in a direction for 10 seconds
func wander(forTimeInSeconds): 
	randomize();
	var coin = randi() % 4;
	if (forTimeInSeconds < 0):
		randomize();
		forTimeInSeconds = randi() % 5;
	if (coin == 0):
		_moveInAsyncWithTimeout(VECTOR_RIGHT, forTimeInSeconds);
	elif (coin == 1):
		_moveInAsyncWithTimeout(VECTOR_LEFT, forTimeInSeconds);
	elif (coin == 2):
		_moveInAsyncWithTimeout(VECTOR_UP, forTimeInSeconds);
	elif (coin == 3): 
		_moveInAsyncWithTimeout(VECTOR_DOWN, forTimeInSeconds);
	# Note: if the method you call has yield it will return immediately do not expect it to block here
	update();
	return;

func follow(position):
	var distance = position - get_global_pos();
	if (abs(distance.x) > abs(distance.y)):
		distance = distance * Vector2(1.0, 0.0);
	elif (abs(distance.x) < abs(distance.y)):
		distance = distance * Vector2(0.0, 1.0);
	var direction = distance.normalized();
	if (distance.length() > 1.5):
		_moveInAsync(direction);

func can_see_player():
	if (_vision.is_colliding()):
		var getObj = _vision.get_collider();
		_debugPrint("Found %s at %s" % [getObj.get_name(), getObj.get_pos()]);
		if _player == null:
			_player = getObj.get_path();
		_canSeePlayer = true;
		_motion = Vector2(0, 0);
	elif (_canSeePlayer):
		_debugPrint("Lost object");
		_canSeePlayer = false;
	return;

func find_player(playerPos):
	_navigationPoints = get_node("../../Navigation2D").get_simple_path(get_global_pos(), playerPos, true);
	if (_navigationPoints.size() > 1):
		follow(_navigationPoints[1]);

func toggleDebug():
	debug = !debug;
	update();
	return;

func toggleWatching():
	isWatching = !isWatching;
	_motion = VECTOR_STOP;
	return;
# "Private" Methods

func _ready():
	set_process(true);
	set_fixed_process(true);
	return;

func _process(delta):
	if (isWatching):
		can_see_player();
	if (isWatching and _player != null):
		find_player(get_node(_player).get_global_pos());
	pass

func _fixed_process(delta):
	if (_motion != Vector2(0, 0)):
		_body.move(_motion.normalized()*speed*delta);
	update();

func _draw():
	if (debug):
		draw_line(_vision.get_pos(), _vision.get_cast_to(), Color(1, 0, 0));
	if (_navigationPoints.size() > 1):
		for p in _navigationPoints:
			draw_circle(p - get_global_pos(), 2, Color(1, 0, 0));

func _debugPrint(message):
	if (debug):
		print("%s@%s - %s" % [self.get_name(), self.get_pos(), message]);

func _moveInAsync(direction):
	_vision.set_cast_to(direction*visionDistance);
	_motion = direction;
	return;
	
func _moveInAsyncWithTimeout(direction, timeInSeconds):
	_moveInAsync(direction);
	_timer._create_timer(self, timeInSeconds, true, "_wander_stop");
	return;
	
func _wander_stop():
	_motion = VECTOR_STOP;
	return

