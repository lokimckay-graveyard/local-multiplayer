@tool
extends Control

var actionsFileResource = "res://addons/local-multiplayer/actions.json"
var cfgFileResource = "res://addons/local-multiplayer/inputMap.godot"
var actionsFilePath

# Requests the OS to opens the actions file
func openActionsFile():
	print("Opening: ", actionsFilePath)
	OS.shell_open(actionsFilePath)

# Push the contents of the actions file into Godot's Input Map settings
func pushToInputMap():
	
	removeAllActions()

	var af = readActionsFile()
	var players = af.players
	var actions = af.actions

	for playerId in players.size():
		var playerDevice = players[playerId]
		var isUsingJoypad = playerDevice != "mouseAndKeyboard"
		for actionName in actions:
			var events = actions[actionName]
			for event in events:
				var isJoypadEvent = event.type == "joypadMotion" || event.type == "joypadButton"
				if (!isUsingJoypad && isJoypadEvent || isUsingJoypad && !isJoypadEvent): continue # Filter out irrelevant events based on player's device
				else: createInputEvent(playerId, actionName, event)

# Deletes all existing actions in the Godot Input Map
func removeAllActions():
	for action in InputMap.get_actions():
		if("spatial_editor/" in action || "ui_" in action): continue # Skip Godot core actions
		InputMap.erase_action(action)

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

# Creates an input event for a given playerId and actionName
func createInputEvent(playerId, actionName, event):
#	var newEvent
#	var deadzone = 0.5
	var _actionName = str(actionName, "_", playerId)
	
#	if event.type == "mouseButton":
#		newEvent = InputEventMouseButton.new()
#		newEvent.set_button_index(event.value)
#	elif event.type == "key":
#		newEvent = InputEventKey.new()
#		newEvent.set_keycode(event.value)
#	elif event.type == "joypadMotion":
#		newEvent = InputEventJoypadMotion.new()
#		newEvent.set_axis(event.axis)
#		newEvent.set_axis_value(event.value)
#	elif event.type == "joypadButton":
#		newEvent = InputEventJoypadButton.new()
#		newEvent.set_button_index(event.value)

#	if event.has("deadzone"): deadzone = event.deadzone
	
	ProjectSettings.set_setting(str("input/", actionName, "_", playerId), event);
	ProjectSettings.save()
#	ProjectSettings.save_custom(cfgFileResource)

#	if !InputMap.has_action(_actionName):
#		InputMap.add_action(_actionName, deadzone) # Add the new action if it doesn't already exist
#
#	InputMap.action_add_event(_actionName, newEvent)

func _enter_tree():
	actionsFilePath = ProjectSettings.globalize_path(actionsFileResource);

func onOpenActionsPressed(): openActionsFile()
func onSavePressed(): pushToInputMap()
