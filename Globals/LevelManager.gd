extends Node

## Custom error types for the error handler.
enum ErrorType {
	## No error.
	NONE = 0,
	# NOT A GODOT ENGINE ERROR!!!
	## Error within the engine; report this bug to the developer.
	ENGINE_ERR = 1,
	## Error with loading assets.
	ASSET_ERR = 2,
	## Error with user scripts.
	CODE_ERR = 3,
	## The issue is unknown.
	UNKNOWN_ERR = 4,
	## UwU x3 *nuzzles you* (Nothing is wrong, this is a dev joke.)
	UWU = 5
};

var errCode:int = 0;
var errTxt:String = "No Error. :D";

signal ready_to_load;

# Dict to load all assets.
var assets:Dictionary = {
	"Engine Fonts": "Assets/Engine/Fonts/",
	"Inline Assets": "Assets/Engine/Inline/",
	"PW Inline": "Assets/Engine/Inline/PW/"
};

func preloaded() -> void:
	print("LevelManager -> Preloader finished, starting.");
	ready_to_load.emit();
	change_level("Story");
	pass

func _ready() -> void:
	pass

func _process(_delta:float) -> void:
	pass

func change_level(level:String, object:bool = false) -> void:
	var levelPath:String = "";
	if object:
		levelPath = "res://Objects/" + level + ".tscn";
	else:
		levelPath = "res://Scenes/" + level + ".tscn";
		
	match level:
		"":
			printerr("LevelManager: Invalid args for level!");
			return;
		_:
			print_debug("Loading " + level + "...");
	# Wait for very last frame, to switch it on a good frame!
	await get_tree().process_frame;
	# Changes the scene to the specified level.
	get_tree().change_scene_to_file(levelPath);
	pass
	
func _err_lvl(level:String = "Error") -> void:
	var levelPath:String = "res://Scenes/" + level + ".tscn";
	printerr("LevelManager -> A fatal error has reported to watchdog!");
	await get_tree().process_frame;
	get_tree().change_scene_to_file(levelPath);
	pass
	
func reload(restart:bool = false) -> void:
	if get_tree().paused == true:
		get_tree().paused = false;
	if restart:
		await get_tree().process_frame;
		get_tree().change_scene_to_file("res://Globals/Preloader.tscn");
		Settings._load_settings();
	else:
		await get_tree().process_frame;
		get_tree().reload_current_scene();

func error(error_code:int = 0, error_text:String = "null") -> void:
	errCode = error_code;
	errTxt = error_text;
	change_level("Error");
	pass
