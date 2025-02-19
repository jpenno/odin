package game

import "core:math/rand"
import rl "vendor:raylib"

Pipe :: struct {
	rect:     rl.Rectangle,
	velocity: rl.Vector2,
	active:   bool,
}

pipe_init :: proc(rect: rl.Rectangle) -> Pipe {
	return Pipe{rect = rect, velocity = rl.Vector2{-200, 0}, active = true}
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

pipe_update :: proc(p: ^Pipe, dt: f32) {
	p.rect.x += p.velocity.x * dt

	if p.rect.x + p.rect.width < 0 {
		p.active = false
	}
}

pipe_draw :: proc(p: Pipe) {
	rl.DrawRectangleRec(p.rect, rl.GREEN)
}
