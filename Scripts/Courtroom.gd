extends Node2D

# Textbox stuff.
@onready var uiCL:CanvasLayer = $GameCam/UI as CanvasLayer;
@onready var textbox:Sprite2D = $GameCam/UI/TextboxVisual as Sprite2D;
@onready var textName:Label = $GameCam/UI/Name as Label;
@onready var textText:Textbox = $GameCam/UI/Textbox as Textbox;

var opacity:float = 0.75;
var selfThink:String = "#68c0f0";
var normal:String = "#ffffff";

@onready var defense:Character = $"CourtBGDef/Defense" as Character;

# Cam
@onready var gameCam:Camera2D = $"GameCam" as Camera2D;
@onready var camAnim:AnimationPlayer = $"cam" as AnimationPlayer;
@onready var camLbl:Label = $"GameCam/Menu/Panel/Cams" as Label;

#signal talking;

"""
0 SIDE_DEF
1 DEF
2 WITNESS
3 PROC
4 JUDGE
"""
var states:Array[String] = ["Side Defense", "Defense", "Witness", "Prosecution", "Judge"];

@onready var curState:int = 1; # Default is defense.

func _ready() -> void:
	pass

func updateTextbox() -> void:
	textbox.modulate = Color(1, 1, 1, opacity); # Set opacity.
	textName.text = GameManager.curName;
	textText.typeStart.connect(_on_text_type_start);
	textText.typeFinish.connect(_on_text_type_finish);
	textText.type();
	pass
	
func _process(_delta:float) -> void:
	if Input.is_action_just_pressed("Debug"):
		($GameCam/Menu as CanvasLayer).visible = !($GameCam/Menu as CanvasLayer).visible;
		pass
	if Input.is_action_just_pressed("Continue"):
		GameManager.continue_script();
		pass
	pass


func switchCamState(nextState:int = 0) -> void:
		uiCL.visible = false;
		match nextState:
			0: # Y: 1080
				match curState:
					0: pass
					1: gameCam.position = Vector2(0,1080);
					2: gameCam.position = Vector2(0,1080);
					3: gameCam.position = Vector2(0,1080);
					4: gameCam.position = Vector2(0,1080);
				curState = nextState;
				pass
			1: # X: 0
				match curState:
					0: gameCam.position = Vector2(0,0);
					1: pass
					2: camAnim.play_backwards("def_to_wit");
					3: camAnim.play_backwards("def_to_proc");
					4: gameCam.position = Vector2(0,0);
				curState = nextState;
				pass
			2: # X: 3494
				match curState:
					0: gameCam.position = Vector2(3494,0);
					1: camAnim.play("def_to_wit");
					2: pass
					3: camAnim.play_backwards("wit_to_proc");
					4: gameCam.position = Vector2(3494,0);
				curState = nextState;
				pass
			3: # X: 6990
				match curState:
					0: gameCam.position = Vector2(6990,0);
					1: camAnim.play("def_to_proc");
					2: camAnim.play("wit_to_proc");
					3: pass
					4: gameCam.position = Vector2(6990,0);
				curState = nextState;
				pass
			4: # Y: -1080
				match curState:
					0: gameCam.position = Vector2(0,-1080);
					1: gameCam.position = Vector2(0,-1080);
					2: gameCam.position = Vector2(0,-1080);
					3: gameCam.position = Vector2(0,-1080);
					4: pass
				curState = nextState;
				pass
		camLbl.text = states[curState];
pass


func _on_text_type_finish() -> void:
	defense.idle();
	pass # Replace with function body.


func _on_text_type_start() -> void:
	#defense.talk("-normal");
	await get_tree().create_timer(1).timeout;
	pass # Replace with function body.


func _on_hide_button_up() -> void:
	($GameCam/CanvasLayer/Menu as Panel).visible = false;
	pass # Replace with function body.


## DEBUG MENU ##
var proposedNextState:int = 1; 
func _on_cam_right_button_up() -> void:
	if states[proposedNextState + 1] == null: return
	proposedNextState += 1 if proposedNextState < 4 else proposedNextState;
	camLbl.text = states[proposedNextState];
	pass

func _on_cam_left_button_up() -> void:
	if states[proposedNextState - 1] == null: return
	proposedNextState -= 1 if proposedNextState > 0 else proposedNextState;
	camLbl.text = states[proposedNextState];
	pass


func _on_submit_button_up() -> void:
	switchCamState(proposedNextState);
	proposedNextState = curState;
	pass


func _on_cam_animation_finished(_anim_name:StringName) -> void:
	uiCL.visible = true;
	pass
