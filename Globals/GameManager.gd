extends Node

var selfThink = "#68c0f0";
var toSelf = false;
var curName = "Phoenix";
var curText = "[color=" + "]Test Textbox with a lot of text how is this even gonna work judge?";

var packMetaPaths = [];

func _read_int_dirs() -> PackedStringArray:
	var dirs = DirAccess.get_directories_at("./Assets/");
	var x = dirs.size()
	for i in x:
		if i >= dirs.size():
			break
		if dirs[i] == "Engine":
			dirs.remove_at(i);
		if dirs[i] == "Other":
			dirs.remove_at(i);
	if Settings.debug:
		print(dirs); # After Edit
	
	for i in dirs.size():
		var packDir = FileAccess.file_exists("./Assets/" + dirs[i] + "/" + dirs[i] + ".acemeta");
		if packDir:
			if Settings.debug:
				print(dirs[i] + ".acemeta - " + dirs[i] + " StoryPack has been found!");
			packMetaPaths.append("./Assets/" + dirs[i] + "/" + dirs[i] + ".acemeta");
	return dirs;

func _da_load():
	print("Target function has been ran.")
	LevelManager.change_level("Courtroom");
	pass

func _ready():
	LevelManager.ready_to_load.connect(self._da_load);
	if get_tree().current_scene.name == "Courtroom":
		read_script();
	pass
	
# Read the story script.
func read_script():
	var dirs = _read_int_dirs();
	
	pass

func _process(delta):
	if Input.is_action_just_pressed("Fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
	pass
