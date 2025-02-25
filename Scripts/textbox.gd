class_name Textbox
extends RichTextLabel

signal typeStart;
signal typeFinish;

func type() -> void:
	typeStart.emit();
	#var tm = Timer.new();
	#tm.start(1);
	#await tm.is_stopped();
	visible_ratio = 0.0;
	text = GameManager.curText;
	var tween: Tween = create_tween();
	tween.set_speed_scale(0.8);
	tween.tween_property(self, "visible_ratio", 1.0, 2.0).from(0.0);
	await tween.finished;
	typeFinish.emit();

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float) -> void:
	pass
