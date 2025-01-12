extends Control

var pressedENTER = false;
var oneTime = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$anim.play("start");
	$anim.queue("idle");
	pass # Replace with function body.

func _enter():
	pressedENTER = false;
	# Prevent scene bullshit...
	if !oneTime:
		oneTime = true;
		# Play SFX - If I had it....
		$CL/EnterText.text = "[center]Press ENTER to continue."
		await get_tree().create_timer(2.5).timeout;
		$anim.play("RESET");
		LevelManager.change_level("Courtroom");
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_ENTER) || Input.is_key_pressed(KEY_KP_ENTER) || Input.is_key_pressed(KEY_SPACE):
		pressedENTER = true;
	else: pressedENTER = false;

	# Do other start things here like anims.
	if pressedENTER:
		_enter();
	pass
