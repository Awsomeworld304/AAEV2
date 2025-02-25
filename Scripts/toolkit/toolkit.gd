extends Control

@onready var cl_start:CanvasLayer = $start as CanvasLayer;
@onready var cl_meta:CanvasLayer = $metadata_editor as CanvasLayer;
@onready var cl_script:CanvasLayer = $script_editor as CanvasLayer;
@onready var cl_char:CanvasLayer = $character_editor as CanvasLayer;
@onready var cl_about:CanvasLayer = $about as CanvasLayer;

func _ready() -> void:
	get_window().size = Vector2i(1280,720);
	get_window().position = Vector2i(300,300);
	FileWatcher.loaded_meta.connect(load_metadata);
	pass

func _process(_delta: float) -> void:
	pass


func _on_choose_btn_button_up() -> void:
	($"start/load_pack" as FileDialog).visible = true;
	pass

func load_metadata() -> void:
	($"metadata_editor/pack_name" as LineEdit).text = FileWatcher.metadata.get("name");
	($"metadata_editor/scr_name" as LineEdit).text = FileWatcher.metadata.get("head_script");
	($"metadata_editor/pack_ver" as LineEdit).text = var_to_str(FileWatcher.metadata.get("version"));
	($"metadata_editor/char_list" as ItemList).clear();
	for charitem in (FileWatcher.metadata.get("characters") as Dictionary):
		($"metadata_editor/char_list" as ItemList).add_item(FileWatcher.metadata.get("characters").get(charitem));
		pass
	pass

func load_scripts() -> void:
	pass

func _on_tabs_tab_changed(tab:int) -> void:
	match tab:
		0:
			cl_start.visible = true;
			cl_meta.visible = false;
			cl_script.visible = false;
			cl_char.visible = false;
			cl_about.visible = false;
			pass
		1:
			cl_start.visible = false;
			cl_meta.visible = true;
			cl_script.visible = false;
			cl_char.visible = false;
			cl_about.visible = false;
			pass
		2:
			cl_start.visible = false;
			cl_meta.visible = false;
			cl_script.visible = true;
			cl_char.visible = false;
			cl_about.visible = false;
			pass
		3:
			cl_start.visible = false;
			cl_meta.visible = false;
			cl_script.visible = false;
			cl_char.visible = true;
			cl_about.visible = false;
			pass
		4:
			cl_start.visible = false;
			cl_meta.visible = false;
			cl_script.visible = false;
			cl_char.visible = false;
			cl_about.visible = true;
			pass
		_: pass
	pass # Replace with function body.

func fix_path(fuf:String) -> String:
	var regex:RegEx = RegEx.new();
	regex.compile("Users/[A-Za-z]+/");
	fuf = fuf.replace(regex.search(fuf).get_string(), "Users/user/");
	return fuf;

func _on_load_pack_file_selected(path:String) -> void:
	FileWatcher.load_pack(path);
	($"start/loaded_file_lbl" as RichTextLabel).text = "Loaded File:\n[font_size=24][color=gray]%s[/color][/font_size]\n%s" % [fix_path(path.get_base_dir()), path.get_file()];
	pass # Replace with function body.


func _on_exit_button_up() -> void:
	LevelManager.reload(true);
	pass # Replace with function body.
