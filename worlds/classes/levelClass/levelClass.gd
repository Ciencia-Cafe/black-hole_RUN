class_name LevelClass extends Node2D

export(String, FILE, "*.tscn") var firstRoom := ""

signal changedRoom

var currentRoom
var currentRoomID := 0
var player

var currentWorld := "sandDesert"

var background

func _ready():
	Global.world = self
	var playerScene = LoadSystem.loadObject("res://entities/player/powerStates/normal/playerNormal.tscn")
#	var playerScene = LoadSystem.loadObject("res://entities/player/powerStates/book/playerBook.tscn")
	
	player = playerScene.instance()
	add_child(player)
	
	call_deferred("loadSave")
	
	AudioManager.playMusic("paintCaverns")
	
	
func setCameraLimits(limitsMin : Vector2, limitsMax : Vector2):
	get_tree().call_group_flags(SceneTree.GROUP_CALL_REALTIME, "player", "setCameraLimits", limitsMin, limitsMax)

func loadSave():
	player.active = false
	
	saveDataRoom()
	
	var currentRoomScene = LoadSystem.loadObject(Global.currentRoom.roomPath)
	
	var backgroundScene = LoadSystem.loadObject("{0}/background.tscn".format([Global.currentRoom.world]))
	
	background = backgroundScene.instance()
	currentRoom = currentRoomScene.instance()
	
	add_child(background)
	call_deferred("add_child", currentRoom)
	
	player.position = Global.save.player["position"]
	
	player.set_deferred("active", true)
	
	LoadSystem.closeLoad()


func loadRoom(room : RoomData):
	player.transition.transitionIn()
	
	yield(player.transition, "transitionedIn")
	emit_signal("changedRoom")
	
	if currentRoom:
		currentRoom.queue_free()
	
	saveDataRoom()
	
	Global.currentRoom = room
	
	loadDataRoom()
	
	if currentWorld != room.world:
		currentWorld = room.world
		
		var backgroundScene = LoadSystem.loadObject("{0}/background.tscn".format([room.world]), false)
		if background:
			background.queue_free()
		
		background = backgroundScene.instance()
		add_child(background)
	
	var currentRoomScene  = LoadSystem.loadObject(room.roomPath, false)
	currentRoom = currentRoomScene.instance()

	add_child(currentRoom)
	currentRoom.init(room.warpID, room.warpType)
	
	player.transition.call_deferred("transitionOut")
	player.resetParticles()

func loadDataRoom():
	if Global.currentRoom.savePath:
		var _1 := 0
		var _2 := 0
		
		if not Global._dir.dir_exists(Global.savePath + "/worldRooms"):
			_1 = Global._dir.make_dir(Global.savePath + "/worldRooms")
		
		if _1:
			print_debug("making {world} path gives the error: {error}".format(
				{"world" : Global.savePath + "/worldRooms", "error" : _1})
			)
		
		if not Global._dir.dir_exists(Global.currentRoom.saveWorldPath):
			_2 = Global._dir.make_dir(Global.currentRoom.saveWorldPath)
		if _2:
			print_debug("making {world} path gives the error: {error}".format(
				{"world" : Global.currentRoom.world.substr(Global.currentRoom.saveWorldPath), "error" : _2})
			)
		
		if Global.roomsToSave.has(Global.currentRoom.savePath):
			Global.currentRoom.data = Global.roomsToSave[Global.currentRoom.savePath].data
		elif Global.saveExist(Global.currentRoom.savePath):
			Global.currentRoom.data = Global.loadData(Global.currentRoom.savePath).data
		

func saveDataRoom():
	if Global.currentRoom.savePath:
		var _1 := 0
		var _2 := 0
		
		if not Global._dir.dir_exists(Global.savePath + "/worldRooms"):
			_1 = Global._dir.make_dir(Global.savePath + "/worldRooms")
		if _1:
			print_debug("making {world} path gives the error: {error}".format(
				{"world" : Global.savePath + "/worldRooms", "error" : _1})
			)
		
		if not Global._dir.dir_exists(Global.currentRoom.saveWorldPath):
			_2 = Global._dir.make_dir(Global.currentRoom.saveWorldPath)
		if _2:
			print_debug("making {world} path gives the error: {error}".format(
				{"world" : Global.currentRoom.world.substr(Global.currentRoom.saveWorldPath), "error" : _2})
			)
		
		if Global.roomsToSave.has(Global.currentRoom.savePath):
			Global.roomsToSave[Global.currentRoom.savePath].data = Global.currentRoom.data
		else:
			Global.roomsToSave[Global.currentRoom.savePath] = Global.currentRoom
