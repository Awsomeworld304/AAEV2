extends Node2D

@onready var errorLabel:RichTextLabel = $msg/Error as RichTextLabel;
@onready var anim:AnimationPlayer = $anim as AnimationPlayer;

var errorCode:int = LevelManager.errCode;
var errorText:String = LevelManager.errTxt;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_error(errorCode, errorText);
	pass

func handle_error(error_code:int, error_text:String) -> void:
	errorLabel.text = "[center][color=red][pulse freq=1.6 color=#ffffff00 ease=-2.0][font_size=38]Error: " + var_to_str(error_code) + "[/font_size][/pulse]\n\n[color=white]" + error_text;
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass


func _on_ok_button_up() -> void:
	anim.play_backwards("start");
	await anim.animation_finished;
	LevelManager.change_level("TitleScreen");
	pass
