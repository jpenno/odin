package game

import "core:fmt"
import "core:math"
import "core:math/linalg"
import rl "vendor:raylib"

Player :: struct {
	Pos:   rl.Vector2,
	Dir:   rl.Vector2,
	Size:  rl.Vector2,
	speed: f32,
}

player_update :: proc(p: ^Player, dt: f32) {
	move(p, dt)
	collision(p)
}

player_draw :: proc(p: Player) {
	dist := p.Pos - rl.GetMousePosition()
	radians := math.atan2(dist.x, dist.y)
	rotation := -radians * 180 / math.PI

	rl.DrawTexturePro(
		textures[.Player].texture,
		textures[.Player].source_rect,
		{
			p.Pos.x,
			p.Pos.y,
			textures[.Player].source_rect.width,
			textures[.Player].source_rect.height,
		},
		{textures[.Player].source_rect.width / 2, textures[.Player].source_rect.height / 2},
		f32(rotation),
		rl.WHITE,
	)
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
