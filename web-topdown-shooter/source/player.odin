package game

import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

Player :: struct {
	Pos:     rl.Vector2,
	Dir:     rl.Vector2,
	Size:    rl.Vector2,
	speed:   f32,
	Bullets: [10]Bullet,
}

player_update :: proc(p: ^Player, dt: f32) {
	move(p, dt)

	if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
		shoot(p, rl.GetMousePosition())
	}

	for &b in p.Bullets {
		if b.active {
			bullet_update(&b, dt)
		}
	}

	collision(p)
}

player_draw :: proc(p: Player) {
	for b in p.Bullets {
		if b.active {
			bullet_draw(b)
		}
	}

	dist := p.Pos - rl.GetMousePosition()
	radians := math.atan2(dist.x, dist.y)
	rotation := -radians * 180 / math.PI

	texture_draw(.Player, p.Pos, rotation)
}

@(private = "file")
move :: proc(p: ^Player, dt: f32) {
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

	p.Dir = linalg.vector_normalize0(p.Dir)
	p.Pos += p.Dir * p.speed * dt
}

@(private = "file")
shoot :: proc(p: ^Player, target: rl.Vector2) {
	for &b in p.Bullets {
		if !b.active {
			b = bullet_init(p.Pos, target)
			break
		}
	}
}

@(private = "file")
collision :: proc(p: ^Player) {
	if p.Pos.x - p.Size.x / 2 <= 0 {
		p.Pos.x = p.Size.x / 2
	}
	if p.Pos.y - p.Size.y / 2 <= 0 {
		p.Pos.y = p.Size.y / 2
	}
	if p.Pos.x + p.Size.x / 2 >= f32(rl.GetScreenWidth()) {
		p.Pos.x = f32(rl.GetScreenWidth()) - p.Size.x / 2
	}
	if p.Pos.y + p.Size.y / 2 >= f32(rl.GetScreenHeight()) {
		p.Pos.y = f32(rl.GetScreenHeight()) - p.Size.y / 2
	}

}
