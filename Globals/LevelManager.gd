extends Node

var errCode := 0;
var errTxt := "No Error. :D";

signal ready_to_load;

# Dict to load all assets.
var assets = {
	"Engine Fonts": "Assets/Engine/Fonts/",
	"Inline Assets": "Assets/Engine/Inline/",
	"PW Inline": "Assets/Engine/Inline/PW/"
}

func preloader():
	var d1 =  DirAccess.get_files_at(assets.get("Engine Fonts"));
	for i in d1.size():
		var path = assets.get("Engine Fonts") + d1[i];
		if path.get_extension() == "import":
			break
		load(path);
		print(d1[i] + " has been loaded!")
	pass

func _ready():
	preloader();
	ready_to_load.emit();
	print("emit has been sent")
	pass

func _process(delta):
	pass

func change_level(level : String, object = false):
	var levelPath = "";
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
	
func _err_lvl(level := "Error"):
	var levelPath = "res://Scenes/" + level + ".tscn";
	printerr("A fatal error has reported to watchdog!");
	await get_tree().process_frame;
	get_tree().change_scene_to_file(levelPath);
	pass
	
func reload(restart = false):
	if get_tree().paused == true:
		get_tree().paused = false;
	if restart:
		await get_tree().process_frame;
		get_tree().change_scene_to_file("res://Scenes/TitleScreen.tscn");
		Settings._load_settings();
	else:
		await get_tree().process_frame;
		get_tree().reload_current_scene();

func error(error_code := errCode, error_text := errTxt):
	# BBL DRIZZY
	errCode = error_code;
	errTxt = error_text;
	change_level("Error");
	pass
