static func list_enemies():
	return {
		type = "LIST_ENEMIES"
	};

static func wander():
	return wander_1(-1);
	
static func wander_1(timeInSeconds):
	return {
		type = "WANDER",
		timeInSeconds = timeInSeconds
	};

static func toggleDebug():
	return {
		type = "TOGGLE_DEBUG"
	};

static func toggleWatching():
	return {
		type = "TOGGLE_WATCHING"
	};

static func findPlayer():
	