extends Control

enum CharacterType {
	DEFENSE = 0,
	WITNESS = 1,
	PROSECUTION = 2
}

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass

func change_character(character:Character) -> Error:
	match character.type:
		0: pass
	return OK;
