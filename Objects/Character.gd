class_name Character
extends Node2D

## The ```AnimatedSprite2D``` of the character.
@onready var animation_controller:AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D;

## The name of the character, not the file name.
var character_name:String = "";
## The default idle animation name. Note: this can be different, thus it can be changed.
var idle_animation_name:String = "default";
## The default talking animation name. Note: this can be different, thus it can be changed.
var talk_animation_name:String = "talk";
## Indicates if the character is speaking or not. Note: do not edit this variable manually.
var speaking:bool = false;

# Internal sprite things.
var valid_animations:PackedStringArray;

func _ready() -> void:
	animation_controller.animation = idle_animation_name;
	pass

func _process(_delta: float) -> void:
	pass

func idle(animation_suffix:String = "") -> void:
	if valid_animations == null: valid_animations = animation_controller.sprite_frames.get_animation_names();

	if !valid_animations.has(idle_animation_name + animation_suffix): return
	animation_controller.animation = idle_animation_name + animation_suffix;
	pass

func talk(animation_suffix:String = "") -> void:
	print_debug("Character -> Talking");
	if valid_animations == null: valid_animations = animation_controller.sprite_frames.get_animation_names();

	if !valid_animations.has(talk_animation_name + animation_suffix): return
	animation_controller.animation = talk_animation_name + animation_suffix;
	pass

func custom(animation_name:String = "") -> void:
	if valid_animations == null: valid_animations = animation_controller.sprite_frames.get_animation_names();

	if !valid_animations.has(animation_name):
		printerr("Character\"{character_name}\" -> Animation \"{animation_name}\" does not exist!");
		return
	animation_controller.animation = animation_name;
	pass
