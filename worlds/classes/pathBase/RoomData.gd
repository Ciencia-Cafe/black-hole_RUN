class_name RoomData extends Resource

var roomPath
var world
var category
var ID
var warpID
var warpType

var debugMode := false

func _init(roomID : int, worldPath : String, Category : String, path : String, WarpID : int, WarpType : String, debug := false):
	debugMode = debug
	
	if roomID != 0:
		path = "{world}/{category}/room{room}.tscn".format({
			"world" : worldPath,
			"category" : Category,
			"room" : roomID
		})
	
	roomPath = path
	world = worldPath
	category = Category
	ID = roomID
	warpID = WarpID
	warpType = WarpType
