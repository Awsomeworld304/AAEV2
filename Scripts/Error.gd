extends Node2D

var errorCode = LevelManager.errCode;
var errorText = LevelManager.errTxt;

# Called when the node enters the scene tree for the first time.
func _ready():
	handle_error(errorCode, errorText);
	pass

func handle_error(error_code, error_text):
	$msg/Error.text = "[center][color=red]Error: " + var_to_str(error_code) + "\n[color=white]" + error_text;
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ok_button_up():
	LevelManager.reload(true);
	pass
