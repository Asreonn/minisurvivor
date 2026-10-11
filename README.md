# MiniSurvivor

A geometric, minimalist survivor-like (Vampire Survivors style) for mobile, built with Godot 4.6. Everything is drawn in code with simple shapes: no sprite assets.

> **Status:** Paused prototype from February 2026. About 3k lines of GDScript.

## Features

- **Auto-firing skills, upgraded on level-up:** orbit blades, aura ring, burst shot, front cone, line beam, edge blades.
- **Skill modifiers:** pierce, electric (chain lightning), chain and bounce.
- **Enemy types:** swarm dots, shooter triangles, bomber squares that leave bomb zones, and elite polygons. Data-driven waves (`data/wave_data.gd`) unlock them over time.
- **Graze system:** enemy bullets that pass close to you count as grazes. Ten grazes trigger *Overcharge* for 5 s (+30% attack speed, 2× pickup range).
- **Progression:** XP shards and crystals, a level-up choice menu, a game-over screen with kills and grazes.
- **Effects:** damage numbers, hit particles, death bursts, trails, screen flash, level-up ring.

## Controls

Drag on the touch screen to move. On desktop, use the arrow keys.

## Run

1. Install [Godot 4.6](https://godotengine.org/download) (Mobile renderer).
2. Open `project.godot` and press **F5**, or export to Android from the editor.

## Layout

```
autoloads/  game_manager.gd (XP, level, graze, skills), events.gd (signal bus)
data/       enemy, wave, skill and modifier definitions
scenes/     arena, player, enemies, skills, projectiles, drops, fx, ui, main
utils/      geometry drawing and math helpers
```
