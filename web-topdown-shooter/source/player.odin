package game

import rl "vendor:raylib"

Player :: struct {
	Pos:   rl.Vector2,
	Dir:   rl.Vector2,
	speed: f32,
}

player_update :: proc(p: ^Player, dt: f32) {
	p.Dir = {0, 0}

	if rl.IsKeyDown(rl.KeyboardKey.W) || rl.IsKeyDown(rl.KeyboardKey.UP) {
		p.Dir.y = -1
	}
	if rl.IsKeyDown(rl.KeyboardKey.S) || rl.IsKeyDown(rl.KeyboardKey.DOWN) {
		p.Dir.y = 1
	}
	if rl.IsKeyDown(rl.KeyboardKey.A) || rl.IsKeyDown(rl.KeyboardKey.LEFT) {
		p.Dir.x = -1
	}
	if rl.IsKeyDown(rl.KeyboardKey.D) || rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
		p.Dir.x = 1
	}

	p.Pos += p.Dir * p.speed * dt
}
