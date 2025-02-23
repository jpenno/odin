package game

import "core:strings"
import rl "vendor:raylib"

Player_action :: enum {
	NONE,
	ATTACK,
}

Player :: struct {
	pos:                rl.Vector2,
	size:               rl.Vector2,
	attack_timer:       Timer,
	attack_flash_timer: Timer,
	score:              int,
}

player_init :: proc() -> Player {
	return Player {
		pos = rl.GetMousePosition(),
		size = rl.Vector2{100, 100},
		attack_timer = timer_init(2),
		attack_flash_timer = timer_init(0.1),
	}
}

player_update :: proc(p: ^Player, dt: f32) -> Player_action {
	p.pos = rl.GetMousePosition()
	p.pos.x -= p.size.x / 2
	p.pos.y -= p.size.y / 2

	if p.attack_flash_timer.state == Timer_state.IN_PORGRESS {
		timer_tick(&p.attack_flash_timer, dt)
	}

	if timer_tick(&p.attack_timer, dt) == Timer_state.DONE {
		timer_set_state(&p.attack_flash_timer, Timer_state.RESET)
		return .ATTACK
	}

	return .NONE
}

player_draw :: proc(p: Player) {
	rl.DrawRectangleV(p.pos, p.size, {0, 0, 255, 100})

	if p.attack_flash_timer.state == Timer_state.IN_PORGRESS {
		rl.DrawRectangleV(p.pos, p.size, {0, 255, 255, 255})
	}
}
