extends Node2D

@onready var datext = $CL/LoadText
@onready var s = load("res://Scenes/TitleScreen.tscn").instantiate();

signal tdone

func switch_to_title():
	await get_tree().create_timer(5).timeout
	get_parent().add_child(s);

# Called when the node enters the scene tree for the first time.
func _ready():
	_loading();
	switch_to_title();
	pass # Replace with function body.

func _loading():
	match datext.get_parsed_text():
		"Loading...":
			datext.text = "[center]Loading";
		_:
			datext.text += ".";
	await get_tree().create_timer(0.5).timeout
	tdone.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_tdone():
	_loading();
	pass # Replace with function body.
