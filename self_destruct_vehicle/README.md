# Self Destruct Vehicle

## Description

Detonates the current driving vehicle on a key press. For those who thrive for chaos.

Both the trigger key and the detonation delay can be adjusted using [Mod Settings](https://www.nexusmods.com/cyberpunk2077/mods/4885), or manually edit the input XML file.

## Installation instructions

1. Install [Redscript](https://www.nexusmods.com/cyberpunk2077/mods/1511) and [Input Loader](https://www.nexusmods.com/cyberpunk2077/mods/4575).
2. Optional: [Mod Settings](https://www.nexusmods.com/cyberpunk2077/mods/4885)
3. Install the downloaded ZIP with a mod manager, or manually extract its contents into the game's root folder.

## Main features

- Press a configurable key while driving to trigger a self-destruct sequence on the current vehicle.
- Configurable delay between the warning sound and the actual explosion (default 5 seconds).

## Changing the key and delay

### Easy way — Mod Settings (recommended)

If **Mod Settings** is installed, open the in-game **Mod Settings** menu and look for the **Self Destruct Vehicle** section. Both the **Detonation Delay** and the **Self Destruct Key** can be changed there, with no file editing required.

### Manual way — editing the XML file

If **Mod Settings** is not installed, you must edit the input mapping file directly:

```text
<Cyberpunk 2077 install folder>\r6\input\self_destruct_vehicle_input.xml
```

Open it in a text editor and change the `id` attribute of the `<button>` element to the key you want. For example, to bind the trigger to **X** instead of **Z**:

```xml
<mapping name="SelfDestructMap" type="Button">
  <button id="IK_X" overridableUI="selfDestructKey" />
</mapping>
```

The `id` must be a valid `EInputKey` name — you can find the full list in the decompiled redscript sources under `EInputKey`. The `overridableUI` attribute must stay as `"selfDestructKey"` so that Mod Settings can still override it if the mod is installed later.

Save the file and restart the game for the change to take effect.

## Requirements

- [Redscript](https://www.nexusmods.com/cyberpunk2077/mods/1511)
- [Input Loader](https://www.nexusmods.com/cyberpunk2077/mods/4575)
- [Mod Settings](https://www.nexusmods.com/cyberpunk2077/mods/4885) *(Optional)*
