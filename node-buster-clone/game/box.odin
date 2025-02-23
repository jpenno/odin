package game

import "core:fmt"
import "core:math/rand"
import rl "vendor:raylib"

Spawn_direction :: enum {
	LEFT,
	RIGHT,
	TOP,
	BOTTOM,
}

// @(private = "file")
// spawn_direition := Spawn_direction.LEFT

Box :: struct {
	size:            rl.Vector2,
	pos:             rl.Vector2,
	speed:           rl.Vector2,
	direction:       rl.Vector2,
	spawn_direction: Spawn_direction,
	active:          bool,
}

box_init :: proc(pos: rl.Vector2) -> Box {
	vel_x := rand.float32_range(0, 2) - 1
	vel_y := rand.float32_range(0, 2) - 1

	return Box {
		pos = pos,
		speed = rl.Vector2{150, 150},
		direction = rl.Vector2{vel_x, vel_y},
		size = rl.Vector2{50, 50},
		active = true,
	}
}

box_spawn :: proc(spawn_dir: Spawn_direction) -> Box {
	vel_x: f32
	vel_y: f32

	pos := rl.Vector2{}
	switch spawn_dir {
	case .LEFT:
		pos.x = -50
		pos.y = f32(rl.GetScreenHeight()) / 2
		vel_x = rand.float32_range(0, 0.5) + 0.5
		vel_y = rand.float32_range(0, 1) - 0.5
	case .RIGHT:
		pos.x = f32(rl.GetScreenWidth()) + 50
		pos.y = f32(rl.GetScreenHeight()) / 2
		vel_x = rand.float32_range(0, 0.5) - 1
		vel_y = rand.float32_range(0, 1) - 0.5
	case .TOP:
		pos.x = f32(rl.GetScreenWidth()) / 2
		pos.y = -50
		vel_x = rand.float32_range(0, 1) - 0.5
		vel_y = rand.float32_range(0, 0.5) + 0.5
	case .BOTTOM:
		pos.x = f32(rl.GetScreenWidth()) / 2
		pos.y = f32(rl.GetScreenHeight()) + 50
		vel_x = rand.float32_range(0, 1) - 0.5
		vel_y = rand.float32_range(0, 0.5) - 1
	}

	return Box {
		pos = pos,
		speed = rl.Vector2{150, 150},
		direction = rl.Vector2{vel_x, vel_y},
		size = rl.Vector2{50, 50},
		active = true,
		spawn_direction = spawn_dir,
	}
}

box_update :: proc(box: ^Box, dt: f32) {
	if !box.active {
		return
	}

	box.pos += box.direction * box.speed * dt

	switch box.spawn_direction {
	case .LEFT:
		if box.pos.x >= f32(rl.GetScreenWidth()) + 10 {
			box.active = false
		}
		if box.pos.y <= 0 || box.pos.y >= f32(rl.GetScreenHeight()) {
			box.active = false
		}
	case .RIGHT:
		if box.pos.x <= 0 - box.size.x + 10 {
			box.active = false
		}
		if box.pos.y <= 0 || box.pos.y >= f32(rl.GetScreenHeight()) {
			box.active = false
		}
	case .TOP:
		if box.pos.y >= f32(rl.GetScreenHeight()) + 10 {
			box.active = false
		}
		if box.pos.x <= 0 || box.pos.x >= f32(rl.GetScreenWidth()) {
			box.active = false
		}
	case .BOTTOM:
		if box.pos.y <= 0 - box.size.y + 10 {
			box.active = false
		}
		if box.pos.x <= 0 || box.pos.x >= f32(rl.GetScreenWidth()) {
			box.active = false
		}
	}

	// if box.pos.x <= 0 || box.pos.x >= f32(rl.GetScreenWidth()) {
	// 	box.active = false
	// }
	//
	// if box.pos.y <= 0 || box.pos.y >= f32(rl.GetScreenHeight()) {
	// 	box.active = false
	// }
}

box_draw :: proc(box: Box) {
	if !box.active {
		return
	}

	rl.DrawRectangleV(box.pos, box.size, rl.RED)
}
