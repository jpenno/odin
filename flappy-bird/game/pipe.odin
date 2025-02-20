package game

import "core:math/rand"
import rl "vendor:raylib"

Pipe_state :: enum {
	ACTIVE,
	SCORED,
	UNACTIVE,
}

Pipe :: struct {
	rect:     rl.Rectangle,
	velocity: rl.Vector2,
	state:    Pipe_state,
}

pipe_init :: proc(rect: rl.Rectangle) -> Pipe {
	return Pipe{rect = rect, velocity = rl.Vector2{-200, 0}, state = .ACTIVE}
}

pipe_spawn_pair :: proc() -> [2]Pipe {
	bordor: f32 = 100
	gap_rect := rl.Rectangle {
		x      = 800,
		height = 400,
	}

	gap_rect.y = rand.float32_range(bordor, f32(rl.GetScreenHeight()) - bordor - gap_rect.height)
	bottom_pipe_height := (f32(rl.GetScreenHeight()) - (gap_rect.y + gap_rect.height))

	pipes := [2]Pipe {
		pipe_init(rl.Rectangle{x = gap_rect.x, y = 0, width = 50, height = gap_rect.y}),
		pipe_init(
			rl.Rectangle {
				x = gap_rect.x,
				y = gap_rect.y + gap_rect.height,
				width = 50,
				height = bottom_pipe_height,
			},
		),
	}

	return pipes
}

pipe_update :: proc(p: ^Pipe, player: ^Player, dt: f32) {
	if p.state == .UNACTIVE {
		return
	}

	if p.state == .ACTIVE {
		if p.rect.x < player.rect.x {
			p.state = .SCORED
			player.score += 1
		}
	}

	p.rect.x += p.velocity.x * dt

	if p.rect.x + p.rect.width < 0 {
		p.state = .UNACTIVE
	}
}

pipe_draw :: proc(p: Pipe) {
	rl.DrawRectangleRec(p.rect, rl.GREEN)
}
