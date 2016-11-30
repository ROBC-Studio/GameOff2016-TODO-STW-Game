extends Node

const BH_RUNNING = "status/running";
const BH_SUCCESS = "status/success";
const BH_FAILURE = "status/failure";
const BH_INVALID = "status/invalid";
const BH_IDLE = "status/idle";

const CM_SELECTOR = "composite/selector";
const CM_RANDOMSELECTOR = "composite/randomSelector";
const CM_SEQUENCE = "composite/sequence";
const LF_CONDITION = "leaf/condition";
const LF_ACTION = "leaf/action";
const LF_SETSTATE = "leaf/setstate";

static func build():
	return BTBuilder.new();

static func makeTree(builder):
	return BTree.new(builder);

class BTree extends Node:
	var _builder;
	var status = "BH_IDLE";
	var _tickFrequencyInSeconds;
	
	func _init(builder, tickFrequencyInSeconds = 4):
		_builder = builder;
		_tickFrequencyInSeconds = tickFrequencyInSeconds;
	
	func _ready():
		# Start the tick
		tick();
	
	func tick():
		_builder.tick();
		
		get_node("/root/MyTimer")._create_timer(self, 0.15, true, "tick");
		return;

# Builds the btree and also the execution engine
class BTBuilder:
	var _nodes = [];
	var _currentIndex = 1;
	var finalized = false;

	# Builder API
	
	# Composite nodes
	func activeSelector():
		if finalized: return;
		var selector = get_script().new();
		print(selector);
		selector._nodes.push_back(CM_SELECTOR);
		
		_nodes.push_back(selector);
		return selector;
		
	func randomSelect():
		if finalized: return;
		var randomSelect = get_script().new();
		randomSelect._nodes.push_back(CM_RANDOMSELECTOR);
		
		_nodes.push_back(randomSelect);
		return randomSelect;

	func sequence():
		if finalized: return;
		var sequence = get_script().new();
		sequence._nodes.push_back(CM_SEQUENCE);
		
		_nodes.push_back(sequence);
		return sequence;
		
 	# Leaf nodes
	func condition(target, toTest, state):
		if _nodes.size() <= 0 or finalized: return;
		_nodes.push_back({
			type = LF_CONDITION,
			execute = funcref(target, toTest),
			withState = state
		});
		return self;

	func action(target, toRun, state):
		if _nodes.size() <= 0 or finalized: return;
		_nodes.push_back({
			type = LF_ACTION,
			execute = funcref(target, toRun),
			withState = state
		});
		return self;

	func finish():
		finalized = true;
		return self;
	
	# Behavior API
	
	# tick function which is essentially the main loop
	func tick():
		if !finalized: return;
		if _currentIndex >= _nodes.size():
			_currentIndex = 1;
		var compositeType = _nodes[0];
		if _nodes[0] == CM_RANDOMSELECTOR:
			randomize();
			var choices = _nodes.size() - 1;
			var choice = (randi() % choices) + 1;
			return execute(_nodes[choice]);
		if _nodes[0] == CM_SELECTOR:
			var choice = _nodes[_currentIndex];
			var result = execute(choice);
			if (result == BH_FAILURE):
				_currentIndex += 1;
				return BH_RUNNING;
			elif (result == BH_RUNNING):
				return BH_RUNNING
			else:
				return BH_SUCCESS;
		if _nodes[0] == CM_SEQUENCE:
			var choice = _nodes[_currentIndex];
			var result = execute(choice);
			if (result == BH_FAILURE):
				return BH_FAILURE;
			elif (result == BH_SUCCESS or result == BH_RUNNING):
				_currentIndex += 1;
			if _currentIndex >= _nodes.size():
				return BH_SUCCESS;
			else:
				return BH_RUNNING;
	
	# this is ghetto as hell, but because Dictionary isn't of type Object I can't reflect the type
	# in the grand scheme of things not really that big of an issue because I will either have a 
	# dictionary which is all the other nodes or a builder object
	func has(ignored):
		return false;

	func execute(choice):
		if (choice.has("type")):
			return executeLeaf(choice);
		else:
			return choice.tick();

	func executeLeaf(obj):
		if !finalized: return;
		var result = obj.execute.call_func(obj.withState);
		if (result):
			return BH_SUCCESS;
		else:
			return BH_FAILURE;