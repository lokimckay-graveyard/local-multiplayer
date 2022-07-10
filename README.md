# Local Multiplayer

Godot plugin that facilitates local multiplayer controls management.  
Saves you having to manually create Input Map actions like `move_forward_p1`, `move_forward_p2`, and so on..

## Usage

1. Copy `addons/local-multiplayer` directory to the same location in your Godot project
1. Enable the plugin via `Project` -> `Project Settings` -> `Plugins` -> `local-multiplayer` -> `Enable`
1. Open the "Local Multiplayer" dock panel that appeared on the left side next to "Scene" and "Import" panels
1. Click "Open JSON file" button to open the `actions.json` file
1. Modify the "players" array as desired ("mouseAndKeyboard" / "joypad" are the valid options)
1. Modify the "actions" dictionary to suit your game's controls
1. Click the "Save actions to Godot's Project Settings" button

Actions configured in `actions.json` are saved across to your Project Settings for each player

## Roadmap

- [x] Setup Project Settings input map using JSON file
- [ ] Configure number of players and devices from UI instead of JSON file
- [ ] Configure actions from UI instead of JSON file
- [ ] Configure number of players and devices at runtime in addition to UI
- [ ] Configure actions at runtime in addition to UI

## Links

- [Keycodes](https://docs.godotengine.org/en/latest/classes/class_@globalscope.html)
