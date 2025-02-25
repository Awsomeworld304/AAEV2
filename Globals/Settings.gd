extends Node

# Static Stuff
var save_file:String = "user://AAEV2/EngineSettings.ace";
var mod_file:String = "user://AAEV2/ModSettings.ace";
var save_dir:String = "user://AAEV2/";

'''
- Version Seed:
 - Changes with each update,
 - prev saves will be read-only and converted to new saves if needed.
 - This is not needed, but you can use it if wanted.
'''
var secret:int = 0;

var debug:bool = true;

# Error Stuff
var errorCode:int = 0;
var errormsg:String = "";

# Graphics
# windowed, borderless windowed, fullscreen, ex. fullscreen.
var fullscreen_mode:int = 2;
var resolutions:Array[Vector2i]  = [Vector2i(1280, 720), Vector2i(1366, 768), Vector2i(1920, 1080)];
var resolution_mode:int = 3;
var fps_options:Array[int] = [30, 60, 120, 140, 144];
var fps_mode:int = fps_options[1]; # Default is 60 FPS.

# Gameplay
# 0 - 5 | Story mode.
var story_mode:int = 0;
var story:String = "MOD";

# Audio
var volume:float = 100.0; # Master
var musicVolume:float = 100.0;
var sfxVolume:float = 100.0;

# Multiplayer
var coopHUDSize:float = 1.0;
var coopMode:bool = false;

func _save_settings() -> void:
	# Setup Save
	var save_items:Dictionary = {
		"key" : secret,
		"fullscreen_mode" : fullscreen_mode,
		"resolution_mode" : resolution_mode,
		"master_volume" : volume,
		"music_volume" : musicVolume,
		"sfx_volume" : sfxVolume,
		"story" : story_mode,
		"coop_mode" : coopMode,
		"coop_hud_size" : coopHUDSize,
		"fps_mode" : fps_mode
	};
	# Save to File
	if !DirAccess.dir_exists_absolute(save_dir):
		DirAccess.make_dir_absolute(save_dir);
	var save_write:FileAccess = FileAccess.open(save_file, FileAccess.WRITE);
	var json_string:String = JSON.stringify(save_items);
	save_write.store_line(json_string);
	save_write.close();
	pass

func _load_settings() -> Error:
	# Load Data from File
	if not FileAccess.file_exists(save_file):
		if debug:
			push_warning("Settings -> Load Settings: No save to load!");
			print_debug("Settings -> Load Settings: Loading default values!");
	var save_read:FileAccess = FileAccess.open(save_file, FileAccess.READ);
	if save_read != null:
		while save_read.get_position() < save_read.get_length():
			var json_pstring:String = save_read.get_line();

			# Creates the helper class to interact with JSON
			var json:JSON = JSON.new();

			# Check if there is any error while parsing the JSON string, skip in case of failure
			var parse_result:int = json.parse(json_pstring);
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_pstring, " at line ", json.get_error_line());
				LevelManager.errCode = parse_result;
				return parse_result as Error;
			var parsed_data:Dictionary = json.get_data();
			
			# Check if save is valid!
			if parsed_data["key"] != secret:
				# Save file has been messed up?
				#get_tree().change_scene_to_file("res://Scenes/Error.tscn"); Not good, use LvlMgr
				LevelManager.error(LevelManager.ErrorType.ENGINE_ERR, "Invalid save file!");
			else:
				parsed_data["fullscreen_mode"] = fullscreen_mode;
				parsed_data["resolution_mode"] = resolution_mode;
				parsed_data["volume"] = volume;
				parsed_data["music_volume"] = musicVolume;
				parsed_data["sfx_volume"] = sfxVolume;
				parsed_data["story"] = story_mode;
				parsed_data["coopMode"] = coopMode;
				parsed_data["coopHUDSize"] = coopHUDSize;
				parsed_data["fps_mode"] = fps_mode;
				if debug:
					print(fullscreen_mode, resolution_mode, volume, story_mode, coopMode, coopHUDSize);
	return OK;

func _load_mod_settings() -> void:
	# Load Data from File
	if not FileAccess.file_exists(mod_file):
		if debug:
			push_warning("Settings -> Load Settings: No save to load!");
			print_debug("Settings -> Load Settings: Loading default values!");
	var save_read:FileAccess = FileAccess.open(mod_file, FileAccess.READ);
	if save_read != null:
		while save_read.get_position() < save_read.get_length():
			var json_pstring:String = save_read.get_line();

			# Creates the helper class to interact with JSON
			var json:JSON = JSON.new();

			# Check if there is any error while parsing the JSON string, skip in case of failure
			var parse_result:int = json.parse(json_pstring);
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_pstring, " at line ", json.get_error_line());
				continue;
			var parsed_data:Dictionary = json.get_data();
			
			# Check if save is valid!
			if parsed_data["key"] != secret:
				#save_read = FileAccess.open(save_file, FileAccess.WRITE);
				#save_read.store_line("{\"Save_Error\"}");
				#save_read.close();
				# File Error?
				get_tree().change_scene_to_file("res://Scenes/Error.tscn");
			else:
				parsed_data["fullscreen_mode"] = fullscreen_mode;
				parsed_data["resolution_mode"] = resolution_mode;
				parsed_data["volume"] = volume;
				parsed_data["music_volume"] = musicVolume;
				parsed_data["sfx_volume"] = sfxVolume;
				parsed_data["story"] = story_mode;
				parsed_data["coopMode"] = coopMode;
				parsed_data["coopHUDSize"] = coopHUDSize;
				parsed_data["fps_mode"] = fps_mode;
				if debug: print(fullscreen_mode, resolution_mode, volume, story_mode, coopMode, coopHUDSize);
	#  Init Data.
	match resolution_mode:
		0: DisplayServer.window_set_size(resolutions[0]);
		1: DisplayServer.window_set_size(resolutions[1]);
		2: DisplayServer.window_set_size(resolutions[2]);
		_: DisplayServer.window_set_size(resolutions[0]);
	
	match fullscreen_mode:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, !DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS));
			
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN);
		3: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
		_: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);

	match story_mode:
		0: story = "AA1";
		1: story = "AA2";
		_: story = "MOD";
	
	match fps_mode:
		30: Engine.max_fps = fps_options[0];
		120: Engine.max_fps = fps_options[2];
		140: Engine.max_fps = fps_options[140];
		144: Engine.max_fps = fps_options[144];
		_: Engine.max_fps = fps_options[1];

	# 0 DB Volume = Full volume. Higher than that will kill your ears. (100db, ouch).
	if volume > 100: volume = 100;
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume - 100);
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), musicVolume - 100);
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfxVolume - 100);
	pass

func _ready() -> void:
	var loadcode:int = _load_settings(); # Inline function.
	if loadcode != OK:
		match loadcode:
			_: LevelManager.error(loadcode, "Error");
