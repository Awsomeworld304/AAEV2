extends Node

var pack_path:String;
var metadata_path:String;

var metadata:Dictionary;
var head_script:Dictionary;
var scripts:Dictionary;

signal loaded_pack
signal loaded_meta

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

## Checks if file is valid, if so, it returns true.
func check_file(file_path:String) -> bool:
	if FileAccess.file_exists(file_path): return true;
	return false;

func save_meta(custom_path:String = "") -> void:
	DirAccess.remove_absolute(metadata_path if custom_path == "" else custom_path);
	var file:FileAccess = FileAccess.open(metadata_path if custom_path == "" else custom_path, FileAccess.WRITE);
	file.store_string(JSON.stringify(metadata));
	file.flush();
	file.close();
	pass

func load_meta() -> void:
	var file:FileAccess = FileAccess.open(metadata_path, FileAccess.READ);
	var json:JSON = JSON.new();
	if json.parse(file.get_as_text()) == OK: metadata = json.data;
	else: print("JSON Parse Error: ", json.get_error_message(), " in ", metadata_path, " at line ", json.get_error_line())
	file.close();
	loaded_meta.emit();
	pass

func _get_head() -> void:
	if !metadata: push_warning("ToolkitLoader -> Metadata is null on head script load!"); return;
	var file:FileAccess = FileAccess.open(metadata_path + "/" + var_to_str(metadata.get("head_script")), FileAccess.READ);
	print("HEAD PATH: %s" % (metadata_path + "/" + metadata.get("head_script")));
	var json:JSON = JSON.new();
	if json.parse(file.get_as_text()) == OK: head_script = json.data;
	else: print("JSON Parse Error: ", json.get_error_message(), " in ", metadata_path, " at line ", json.get_error_line())
	file.close();
	pass

func _load_script(file_path:String) -> void:
	if !metadata: push_warning("ToolkitLoader -> Metadata is null on script load!"); return;
	var file:FileAccess = FileAccess.open(metadata_path + "/" + var_to_str(metadata.get("head_script")).get_base_dir() + "/" + file_path, FileAccess.READ);
	var json:JSON = JSON.new();
	file.close();
	if json.parse(file.get_as_text()) == OK: scripts.get_or_add(json.data);
	else: print("JSON Parse Error: ", json.get_error_message(), " in ", metadata_path, " at line ", json.get_error_line())
	pass

func load_scripts() -> void:
	_get_head();
	for scr:String in head_script:
		print("ToolkitLoader -> load scripts scr: %s" % scr);
		#_load_script(scr);
		pass
	pass

func load_pack(metadata_file_path:String) -> void:
	if !DirAccess.dir_exists_absolute(metadata_file_path.get_base_dir()): return;
	pack_path = metadata_file_path.get_base_dir();
	metadata_path = metadata_file_path;
	loaded_pack.emit();
	load_meta();
	#load_scripts();
	pass
