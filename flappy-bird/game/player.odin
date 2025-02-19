package game

import "core:fmt"
import rl "vendor:raylib"

Player :: struct {
	rect:          rl.Rectangle,
	color:         rl.Color,
	velocity:      rl.Vector2,
	gravity:       f32,
	gravity_acell: f32,
	jump_force:    f32,
}

player_init :: proc() -> Player {
	return Player {
		rect = rl.Rectangle{x = 100, y = 100, width = 100, height = 100},
		color = rl.BLUE,
		gravity = 500,
		gravity_acell = 3_000,
		jump_force = -900,
	}
}

player_update :: proc(p: ^Player, dt: f32) {
	if p.velocity.y < p.gravity {
		p.velocity.y += p.gravity_acell * dt
	} else {
		p.velocity.y = p.gravity
	}

	if rl.IsKeyPressed(.SPACE) {
		p.velocity.y = p.jump_force
	}

	p.rect.y += p.velocity.y * dt
}

player_draw :: proc(p: Player) {
	rl.DrawRectangleRec(p.rect, p.color)
}
