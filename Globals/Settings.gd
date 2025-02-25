"""
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
	get_window().title = "Ace Attorney Engine V2";
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

func change(key:String, value:String="", value2:String="", save_settings:bool=false) -> void:
	match key:
		"max_framerate", "fps":
			if value.is_empty() or int(value) <= 0: 
				max_framerate = 60;
				Engine.max_fps = max_framerate;
				printerr("Settings (change) -> Invalid Framerate! Using default. (60)");
				print("Settings -> New FPS: " + var_to_str(max_framerate));
			else:
				max_framerate = int(value);
				Engine.max_fps = max_framerate;
				print("Settings (change) -> New FPS: " + var_to_str(max_framerate));
			pass
		"resolution", "res":
			if value2 != null:
				var new_res:Vector2i = Vector2i(int(value), int(value2));
				DisplayServer.window_set_size(new_res);
			elif value != null:
				DisplayServer.window_set_size(resolutions[int(value)]);
			else:
				printerr("Settings (change) -> Invalid resolution!");
		_:
			printerr("Settings (change) -> Invalid setting key!");
	if save_settings && _save_settings() != OK: LevelManager.error("Save error during settings save!");
	pass

func _ready() -> void:
	var loadcode:int = _load_settings(); # Inline function.
	if loadcode != OK:
		match loadcode:
			_: LevelManager.error(loadcode, "Error");
"""

# Copyright (C) 2024 JamesTech4849
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

extends Node

# Static Stuff
const save_file:String = "user://AAEV2/EngineSettings.ace";
const mod_file:String = "user://AAEV2/ModSettings.ace";
const save_dir:String = "user://AAEV2/";

## File Version - Used in case of the settings updating.
const secret:int = 1;

var debug:bool = true;

## A flag that triggers a function to save in some conditions.[br]
## Do NOT manually set this flag! You will absolutely throw the engine off and permanently destroy the engine save files!
var _save_flag:bool = false;

# Error Stuff
var errorCode:int = 0;
var errormsg:String = "";

# Graphics
# windowed, borderless windowed, fullscreen, ex. fullscreen.
var fullscreen_mode:int = 0;
var resolutions:Array[Vector2i]  = [Vector2i(640, 360), Vector2i(1280, 720), Vector2i(1920, 1080), Vector2i(2560, 1080)];
var resolution_mode:int = 2;
var max_framerate:int = 144;

# Gameplay
var story_mode:int = 0;
var story:String = "NONE";

# Audio
var volume:float = 100.0; # Master
var musicVolume:float = 100.0;
var sfxVolume:float = 100.0;

## Saves engine variables and settings to save file.[br]
## The file can be located at ```user://AO/EngineSettings.sav```.
func _save_settings() -> Error:
	# Setup Save
	var save_items:Dictionary = {
		"key" : secret,
		"fullscreen_mode" : fullscreen_mode,
		"resolution_mode" : resolution_mode,
		"master_volume" : volume,
		"music_volume" : musicVolume,
		"sfx_volume" : sfxVolume,
		"story" : story_mode,
		"max_framerate" : max_framerate,
		"debug" : debug
	};
	# Save to File
	if !DirAccess.dir_exists_absolute(save_dir):
		if DirAccess.make_dir_absolute(save_dir) != OK: return DirAccess.get_open_error();
	var save_write:FileAccess = FileAccess.open(save_file, FileAccess.WRITE);
	var json_string:String = JSON.stringify(save_items);
	save_write.store_line(json_string);
	save_write.close();
	if save_write.get_error() != OK && save_write.get_error() != null: return save_write.get_error();
	elif save_write.get_error() == null: return FileAccess.get_open_error();
	return OK;

## Loads the engine/settings save file.
func _load_settings() -> Error:
	# Load Data from File
	if not FileAccess.file_exists(save_file):
		_save_flag = true;
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
			var parse_result:Error = json.parse(json_pstring);
			if not parse_result == OK:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_pstring, " at line ", json.get_error_line());
				#LevelManager.errCode = parse_result 
				return parse_result;
			
			var parsed_data:Dictionary = json.get_data();
			
			# Check if save is the correct version.
			if parsed_data["key"] != secret:
				# Save file needs to update.
				if parsed_data["key"] == 0:
					print("Settings -> Converting old save to new version.");
					fullscreen_mode = parsed_data["fullscreen_mode"];
					resolution_mode = parsed_data["resolution_mode"];
					volume = parsed_data["volume"];
					musicVolume = parsed_data["music_volume"];
					sfxVolume = parsed_data["sfx_volume"];
					story_mode = parsed_data["story"];
					max_framerate = parsed_data["fps_mode"];
					_save_flag = true;
				else:
					LevelManager.error(1, "Invalid Save File!");
			else:
				fullscreen_mode = parsed_data["fullscreen_mode"];
				resolution_mode = parsed_data["resolution_mode"];
				volume = parsed_data["master_volume"];
				musicVolume = parsed_data["music_volume"];
				sfxVolume = parsed_data["sfx_volume"];
				story_mode = parsed_data["story"];
				max_framerate = parsed_data["max_framerate"];
				debug = parsed_data["debug"];
				if debug:
					print(fullscreen_mode, resolution_mode, volume, story_mode, max_framerate, _save_flag);
	# Set settings.
	match resolution_mode:
		0: DisplayServer.window_set_size(resolutions[0]);
		1: DisplayServer.window_set_size(resolutions[1]);
		2: DisplayServer.window_set_size(resolutions[2]);
		3: DisplayServer.window_set_size(resolutions[3]);
		_: DisplayServer.window_set_size(resolutions[0]);
	
	match fullscreen_mode:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, !DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS));
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN);
		_: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED);

	match story_mode:
		0: story = "Campaign";
		_: story = "null";
	
	Engine.max_fps = max_framerate;
	
	# 0 DB Volume = Full volume. Higher than that will kill your ears. (100db, ouch).
	if volume > 100:
		volume = 100;
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume - 100);
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), musicVolume - 100);
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfxVolume - 100);
	return OK;

## Loads mod settings into global access.[br]
## Not complete yet!
func _load_mod_settings() -> Error:
	return OK;

func change(key:String, value:String="", value2:String="", save_settings:bool=false) -> void:
	match key:
		"max_framerate", "fps":
			if value.is_empty() or int(value) <= 0: 
				max_framerate = 60;
				Engine.max_fps = max_framerate;
				printerr("Settings (change) -> Invalid Framerate! Using default. (60)");
				print("Settings -> New FPS: " + var_to_str(max_framerate));
			else:
				max_framerate = int(value);
				Engine.max_fps = max_framerate;
				print("Settings (change) -> New FPS: " + var_to_str(max_framerate));
			pass
		"resolution", "res":
			if value2 != null:
				var new_res:Vector2i = Vector2i(int(value), int(value2));
				DisplayServer.window_set_size(new_res);
			elif value != null:
				DisplayServer.window_set_size(resolutions[int(value)]);
			else:
				printerr("Settings (change) -> Invalid resolution!");
		_:
			printerr("Settings (change) -> Invalid setting key!");
	if save_settings && _save_settings() != OK: LevelManager.error(1, "Save error during settings save!");
	pass

func _ready() -> void:
	if  _load_settings() != OK:
		print("Settings Error!");
		LevelManager.error(1, "Error during settings load!");
	if _save_flag: if _save_settings() != OK: LevelManager.error(1, "Save error during settings save!");

func _process(_delta: float) -> void:
	pass
