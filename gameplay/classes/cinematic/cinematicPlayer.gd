class_name CutScene extends AnimationPlayer

export(Array, Texture) var images
export var saveGameAfter := true
var dialogs

func setup(Dialogs):
	dialogs = Dialogs

func _start():
	Global.player.setCinematic(true)

func _end():
	Global.player.setCinematic(false)
	if saveGameAfter:
		Global.saveGameData()

func _setDialog(index := 0):
	if not Global.playerHud.dialog.opened:
		Global.playerHud.dialog.open(dialogs[index], images)
		

