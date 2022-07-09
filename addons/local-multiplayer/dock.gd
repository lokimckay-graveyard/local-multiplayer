extends Control

var assignInputPopup

# Called when the node enters the scene tree for the first time.
func _ready():
	assignInputPopup = get_node("AssignInputPopup")
	assignInputPopup.popup()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
