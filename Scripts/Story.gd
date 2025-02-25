extends Node2D

@onready var datext:RichTextLabel = $CL/LoadText as RichTextLabel;
@onready var s:Node = (load("res://Scenes/TitleScreen.tscn") as PackedScene).instantiate();

signal tdone

func switch_to_title() -> void:
	await get_tree().create_timer(5).timeout
	get_parent().add_child(s);

func _ready() -> void:
	_loading();
	switch_to_title();
	pass

func _loading() -> void:
	match datext.get_parsed_text():
		"Loading...":
			datext.text = "[center]Loading";
		_:
			datext.text += ".";
	await get_tree().create_timer(0.5).timeout
	tdone.emit()

func _process(_delta:float) -> void:
	pass

func _on_tdone() -> void:
	_loading();
	pass
