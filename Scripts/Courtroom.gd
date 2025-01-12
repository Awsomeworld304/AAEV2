extends Node2D

# Textbox stuff.
@onready var textbox = $GameCam/Textbox;
@onready var textName = $GameCam/Textbox/Name;
@onready var textText = $GameCam/Textbox/Text;
var opacity = 0.75;
var selfThink = "#68c0f0";
var normal = "#ffffff";
var wit = false;

signal talking;

"""
-1 SIDE_DEF
0 DEF
1 WITNESS
2 PROC
3 JUDGE
"""
var states = ["Side Defense", "Defense", "Witness", "Prosecution", "Judge"];

@onready var curState = states[1]; # Defualt is defense.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$AnimationPlayer.stop(false);
	#$AnimationPlayer.play("blink_oc-loop");
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play();
	pass # Replace with function body.

func updateTextbox() -> void:
	textbox.modulate = Color(1, 1, 1, opacity); # Set opacity.
	textName = GameManager.curName;
	textText.type();
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if Input.is_action_just_pressed("Continue"):
		if !wit:
			$GameCam/Textbox.visible = false;
			$cam.play("def_to_wit");
			await $cam.animation_finished
			$GameCam/Textbox.visible = true;
			wit = true;
		else:
			$GameCam/Textbox.visible = false;
			$cam.play_backwards("def_to_wit");
			await $cam.animation_finished
			$GameCam/Textbox.visible = true;
			wit = false;
	if Input.is_action_just_pressed("Debug"):
		$GameCam/Menu.visible = !$GameCam/Menu.visible;
	pass


func switchCamState(val = 0) -> void:
		match val:
			-1:
				pass
			0:
				pass
			1:
				pass
			2:
				pass
			3:
				pass
		$"../Cams".text = curState;
pass


func _on_text_type_finish():
	$AnimationPlayer.play("blink_oc-loop");
	pass # Replace with function body.


func _on_text_type_start():
	$AnimationPlayer.play("talk_normal-loop");
	await get_tree().create_timer(1).timeout;
	pass # Replace with function body.


func _on_hide_button_up():
	$GameCam/CanvasLayer/Menu.visible = false;
	pass # Replace with function body.


## DEBUG MENU ## 
func _on_cam_right_button_up():
	match curState:
		-1:
			curState = states[0];
			switchCamState(curState);
		0:
			curState = states[1];
			switchCamState(curState);
		1:
			curState = states[2];
			switchCamState(curState);
		2:
			curState = states[3];
			switchCamState(curState);
	pass

func _on_cam_left_button_up():
	match curState:
		0:
			curState = states[-1];
			switchCamState(curState);
		1:
			curState = states[0];
			switchCamState(curState);
		2:
			curState = states[1];
			switchCamState(curState);
		3:
			curState = states[2];
			switchCamState(curState);
	pass
