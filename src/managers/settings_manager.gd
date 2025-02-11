extends Node

## Manages the backend values for settings such as volume.

## Signal emitted when the master volume has updated.
signal master_volume_updated(new_value: float)
## Signal emitted when the music volume has updated.
signal music_volume_updated(new_value: float)
## Signal emitted when the SFX volume has updated.
signal sfx_volume_updated(new_value: float)

## The master volume of the game.
var master_volume: float = 0.75:
	get:
		return master_volume
	set(value):
		master_volume = clamp(value, 0.0, 1.0)
		master_volume_updated.emit(master_volume)

## The music volume of the game.
var music_volume: float = 1.0:
	get:
		return music_volume
	set(value):
		music_volume = clamp(value, 0.0, 1.0)
		music_volume_updated.emit(music_volume)

## The SFX volume of the game.
var sfx_volume: float = 1.0:
	get:
		return sfx_volume
	set(value):
		sfx_volume = clamp(value, 0.0, 1.0)
		sfx_volume_updated.emit(sfx_volume)
