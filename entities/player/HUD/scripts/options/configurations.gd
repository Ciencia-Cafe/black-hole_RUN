extends Control

onready var propertiesList = {
	"simpleLight" : $Panel/VBoxContainer/HBoxContainer/CheckButton,
	"music" : $Panel/VBoxContainer/music,
	"sfx" : $Panel/VBoxContainer/sound
}


func _ready():
	propertiesList["simpleLight"].pressed = Global.options.simpleLight
	propertiesList["music"].value = Global.options.musicVolume
	propertiesList["sfx"].value = Global.options.sfxVolume

func _input(_event):
	if Input.is_action_just_pressed("menu") and $"../../".currentScreen in ["HUD", "CONF"]:
		visible = not visible
		$"../../HUD".visible = not visible
		
		if visible:
			$"../../".currentScreen = "CONF"
		else:
			$"../../".currentScreen = "HUD"

func _on_SImpleLight_toggled(button_pressed):
	Global.emit_signal("simpleLightChanged", button_pressed)
	Global.saveData(Global.optionsSavePath, Global.options)

func _on_close_pressed():
	visible = false
	$"../../HUD".visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	get_tree().paused = false
	LoadSystem.loadScene($"../../../../", LoadSystem.MAIN_SCENE, true)

func _on_configurations_visibility_changed():
	get_tree().paused = visible

func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear2db(value))
	Global.options.musicVolume = value

func _on_sound_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value))
	Global.options.sfxVolume = value

func _on_drag_ended(_value_changed):
	Global.saveData(Global.optionsSavePath, Global.options)
