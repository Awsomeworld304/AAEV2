extends Control

@onready var anim:AnimationPlayer = $anim as AnimationPlayer;
@onready var enterText:RichTextLabel = $CL/EnterText as RichTextLabel;

var pressedENTER:bool = false;
var oneTime:bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("start");
	anim.queue("idle");
	pass # Replace with function body.

func _enter() -> void:
	pressedENTER = false;
	# Prevent scene bullshit...
	if !oneTime:
		oneTime = true;
		# Play SFX - If I had it....
		enterText.text = "[center]Press ENTER to continue."
		# Wait for idle to finish after stopping loop.
		anim.get_animation(anim.current_animation).loop_mode = Animation.LOOP_NONE;
		await anim.animation_finished;
		# Cleanly fade out.
		anim.play("end");
		await anim.animation_finished;
		LevelManager.change_level("Courtroom");
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	if Input.is_key_pressed(KEY_ENTER) || Input.is_key_pressed(KEY_KP_ENTER) || Input.is_key_pressed(KEY_SPACE):
		pressedENTER = true;
	else: pressedENTER = false;

	if Input.is_action_just_pressed("Debug"): ($debug_menu as CanvasLayer).visible = !($debug_menu as CanvasLayer).visible;
	pass

	# Do other start things here like anims.
	if pressedENTER:
		_enter();
	pass


func _on_go_to_toolkit_button_up() -> void:
	LevelManager.change_level("toolkit/toolkit");
	pass
