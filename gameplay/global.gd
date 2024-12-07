extends Node

const optionsSavePath = "user://options.tres"

onready var player : PlayerBase
onready var playerHud : PlayerHud
onready var languagesID : Array
onready var canvasModulate := CanvasModulate.new()

var options : OptionsSave

var save : SaveGame
var savePath : String
var world : Node
var worldData : Dictionary
var worldDataSetup := false

signal simpleLightChanged(value)
signal shadowsChanged(value)

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	get_parent().call_deferred("add_child", canvasModulate)
	
	var _dir := Directory.new()
	
	if not _dir.dir_exists("user://userData"):
		var _2 = _dir.make_dir("user://userData")
	
	if not _dir.dir_exists("user://userData/saves"):
		var _2 = _dir.make_dir("user://userData/saves")
		
	if not FileSystemHandler.fileExist(optionsSavePath):
		FileSystemHandler.saveDataResource(optionsSavePath, OptionsSave.new())
		
	options = FileSystemHandler.loadDataResource(Global.optionsSavePath)
	
	setup_langueges()
	
func _input(_event):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

func compareFloats(a : float, b : float, tolerance := 0.000001):
	return abs(a - b) < tolerance

func _setSimpleLight(value):
	emit_signal("simpleLightChanged", value)
	options.simpleLight = value

func _setShadow(value):
	emit_signal("shadowsChanged", value)
	options.shadows = value

func addToRoomData(_obj_name : String, _catergory : String):
	pass
#	if not obj_name in currentRoom.data[catergory]:
#
#		currentRoom.data[catergory].append(obj_name)

func setup_langueges():
	if not options.lang:
		options.lang = TranslationServer.get_locale()
		FileSystemHandler.saveDataResource(Global.optionsSavePath, Global.options)
	else:
		TranslationServer.set_locale(options.lang)
	
	for locale in TranslationServer.get_loaded_locales():
		if languagesID.has(locale): continue
		
		languagesID.append(locale) 

func set_languege(index):
	var locale : String = languagesID[index]
	
	TranslationServer.set_locale(locale)
	options.lang = TranslationServer.get_locale()
	FileSystemHandler.saveData(optionsSavePath, options)

func bin_array(n : int, size := 8):
	var ret_array := []
	
	while n > 0:
		ret_array.insert(0, n&1)
		n = n>>1
	
	while ret_array.size() < size:
		ret_array.insert(0, 0)
	
	print(ret_array)
	return ret_array
