extends LineEdit

onready var response_node = get_node("Response");
onready var Store = get_node("/root/Store");

const EnemyActions = preload("res://EnemiesActions.gd");
const PlayersActions = preload("res://PlayersActions.gd");

const terminal_prefix = ">> ";
const terminal_format = ">> %s";

var tapped = false;
var isInitialized = false;
var originalColor = Color(0.0, 0.0, 0.0);

func _ready():
	hide();
	originalColor = get_node("Response").get_color("font_color");

func _input_event(event):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed):
		set_error("test error");
	if (event.type == InputEvent.KEY and event.pressed and event.scancode == KEY_RETURN):
		response_node.add_color_override("font_color", originalColor);
		var commands = get_text().split('|');
		
		for command in commands:
			if (command.begins_with("ls")):
				Store.dispatch(EnemyActions.list_enemies());
			if (command.begins_with("wander")):
				Store.dispatch(EnemyActions.wander());
			if (command.begins_with("affect_me")):
				Store.dispatch(PlayersActions.affect_player(0));
		# Send the action to the event

func initialize(): 
	if (!isInitialized):
		show();
		set_text('');
		response_node.set_text('');
		isInitialized = true;

func close():
	release_focus();
	hide();
	isInitialized = false;

func set_error(errorMessage): 
	response_node.add_color_override("font_color", Color(1.0, 0.0, 0.0));
	response_node.set_text("ERROR! %s" % errorMessage);