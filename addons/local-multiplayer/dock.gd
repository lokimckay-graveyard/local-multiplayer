@tool
extends Control

var actionsFileResource = "res://addons/local-multiplayer/actions.json"
var actionsFilePath

# Requests the OS to opens the actions file
func openActionsFile():
	print("Opening: ", actionsFilePath)
	OS.shell_open(actionsFilePath)

# Saves the contents of the actions file into Godot's Project Settings
func saveToProjectSettings():
	var af = readActionsFile()
	var players = af.players
	var actions = af.actions
	var joypadCounter = 0
	for playerId in players.size():
		var playerDevice = players[playerId]
		var playerJoypad
		var isUsingJoypad = playerDevice != "mouseAndKeyboard"
		if(isUsingJoypad):
			playerJoypad = joypadCounter
			joypadCounter += 1
		for actionName in actions:
			var action = actions[actionName]
			createInputAction(playerId, playerJoypad, actionName, action)
	ProjectSettings.save()

# Reads and returns the actions.json file contents
func readActionsFile():
	var file = File.new()
	file.open(actionsFilePath, File.READ)
	var content = file.get_as_text()
	file.close()
	var json = JSON.new()
	var error = json.parse(content)
	if error != OK:
		print("Actions file could not be read: ", json.get_error_message(), " at line ", json.get_error_line())
		return false
	else:
		return json.get_data()

# Creates an input action for a given playerId and actionName
func createInputAction(playerId, playerJoypad, actionName, action):
	var settingName = str("input/", actionName, "_", playerId)
	var inputAction: Dictionary
	inputAction.deadzone = action.deadzone if action.deadzone != null else 0.5
	inputAction.events = []
	for event in action.events:
		var newEvent
		var isJoypadEvent = event.type == "joypadMotion" || event.type == "joypadButton"
		if ((playerJoypad == null && isJoypadEvent) 
			|| (playerJoypad != null && !isJoypadEvent)): continue # Filter out irrelevant events based on player's device
		if event.type == "mouseButton":
			newEvent = InputEventMouseButton.new()
			newEvent.set_button_index(event.value)
		elif event.type == "key":
			newEvent = InputEventKey.new()
			newEvent.set_physical_keycode(event.value)
		elif event.type == "joypadMotion":
			newEvent = InputEventJoypadMotion.new()
			newEvent.set_axis(event.axis)
			newEvent.set_axis_value(event.value)
		elif event.type == "joypadButton":
			newEvent = InputEventJoypadButton.new()
			newEvent.set_button_index(event.value)
		newEvent.device = playerJoypad || 0
		inputAction.events.append(newEvent)
	
	if(inputAction.events.size() > 0): ProjectSettings.set_setting(settingName, inputAction);

func _enter_tree():
	actionsFilePath = ProjectSettings.globalize_path(actionsFileResource);

func onOpenActionsPressed(): openActionsFile()
func onSavePressed(): saveToProjectSettings()
