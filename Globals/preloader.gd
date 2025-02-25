extends Control

@onready var pbar:ProgressBar = $CL/EngineLogo as ProgressBar;
@onready var anim:AnimationPlayer = $anim as AnimationPlayer;

# Dict to load all assets.
var assets:Dictionary = {
	"Engine Fonts": "Assets/Engine/Fonts",
	"Inline Assets": "res://Assets/Engine/Inline",
	"PW Inline": "res://Assets/Engine/Inline/PW",
	"Engine Scenes": "res://Scenes",
	"Engine Objects": "res://Objects",
	"Engine Scripts": "res://Scripts"
};

var file_paths:Array[String];
var done_init:bool = false;
var total_files:int = 1;
var loaded_files:int = 0;
var found_error:bool = false;

## Returns True if the path is valid, otherwise false.
func check_path(path:String) -> bool:
	var verdict:bool = false;
	var dirHandle:DirAccess = DirAccess.open("res://");
	#verdict = dirHandle != null;
	if dirHandle.change_dir(path) != OK: printerr("Preloader -> Path (%s) is not valid!" % path);
	print("Open Error: %s" % DirAccess.get_open_error());
	return verdict;

func start_load(dir_path:String) -> void:
	var d1:PackedStringArray = DirAccess.get_files_at(dir_path);
	var d2:PackedStringArray = DirAccess.get_directories_at(dir_path);

	# Load files in our subdirectories.	
	for i:int in d2.size():
		start_load(dir_path + d2[i]);
		pass
	
	# Loads files in the root directory of our path.
	for i:int in d1.size():
		var path:String = dir_path + d1[i];
		if path.get_extension() == "import": continue;
		file_paths.append(path);
		print_debug(path);
		ResourceLoader.load_threaded_request(path);
		if Settings.debug: print("Preloader -> Requesting file \"{d1[i]}\" load.");
	pass


func get_progress() -> void:
	for i:int in file_paths.size():
		var code:int = ResourceLoader.load_threaded_get_status(file_paths[i]);
		if code == ResourceLoader.THREAD_LOAD_LOADED: loaded_files += 1;
		elif (code == ResourceLoader.THREAD_LOAD_FAILED):
			printerr("Preloader -> Error loading asset: \"{file_paths[i]}\". Skipping...");
		elif (code == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE):
			printerr("Preloader -> Error loading invalid asset: \"{file_paths[i]}\". Skipping...");
		pass
	if loaded_files == total_files: done();
	pbar.value = loaded_files;
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Init some stuff to prevent crashes.
	file_paths = [];

	for i:String in assets:
		if check_path(var_to_str(assets.get(i))): start_load(var_to_str(assets.get(i)));
		pass
	anim.play("start");
	await anim.animation_finished;
	total_files = file_paths.size();
	if total_files == 0: found_error = true; done();
	
	done_init = true;
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	total_files = file_paths.size();
	if done_init && !found_error: get_progress();
	pass

func done() -> void:
	anim.play("end");
	await anim.animation_finished;
	if !found_error: LevelManager.preloaded();
	else: LevelManager.error(LevelManager.ErrorType.ASSET_ERR, "Assets could not be preloaded!");
	pass