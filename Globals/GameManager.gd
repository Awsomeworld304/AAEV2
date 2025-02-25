extends Node

enum CamPositions {
	SIDE_DEF = 0,
	DEF = 1,
	WITNESS = 2,
	PROC = 3,
	JUDGE = 4
};

var selfThink:String = "#68c0f0";
var toSelf:bool = false;
var curName:String = "Phoenix";
var curText:String = "[color=" + "]Test Textbox with a lot of text how is this even gonna work, Your Honor?";

var _script_position:int = 0;

var _script_metadata:Dictionary = {};
var _script_text:Array = [];

var packMetaPaths:Array = [];

## Starting signal to let listeners know that the script is setup and starting.
signal script_start();
## Signal to let listeners know that the script is moving forward by one.
signal script_step(current_step:int);

func _read_int_dirs() -> PackedStringArray:
	var dirs:PackedStringArray = DirAccess.get_directories_at("./Assets/");
	var x:int = dirs.size()
	for i:int in x:
		if i >= dirs.size():
			break
		if dirs[i] == "Engine": dirs.remove_at(i);
		if dirs[i] == "Other": dirs.remove_at(i);
	if Settings.debug: print("GameManager -> Edited Directories: %s" % dirs); # After Edit
	
	for i:int in dirs.size():
		var packDir:bool = FileAccess.file_exists("./Assets/" + var_to_str(dirs[i]) + "/" + var_to_str(dirs[i]) + ".acemeta");
		if packDir:
			if Settings.debug:
				print("%s.acemeta	 - %s StoryPack has been found!" % dirs[i]);
			packMetaPaths.append("./Assets/" + dirs[i] + "/" + dirs[i] + ".acemeta");
	return dirs;

func _da_load() -> void:
	print("GameManager -> Initial loading has been complete.")
	LevelManager.change_level("Courtroom");
	pass

func _ready() -> void:
	LevelManager.ready_to_load.connect(self._da_load);
	if get_tree().current_scene.name == "Courtroom":
		read_script();
	pass
	
# Read the story script and starts at the beginning.
func read_script() -> void:
	#var dirs:PackedStringArray = _read_int_dirs();
	script_start.emit();
	pass

## Increments the script by one, loads current text, and emits a signal.
func continue_script() -> void:
	# Increment the position.
	_script_position += 1;
	# Setup current text.
	# Emit signal to trigger listeners.
	script_step.emit(_script_position);
	pass

func _process(_delta:float) -> void:
	if Input.is_action_just_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
	pass
