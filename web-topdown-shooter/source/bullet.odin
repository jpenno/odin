package game

import "core:math/linalg"
import rl "vendor:raylib"

Bullet :: struct {
	Pos:    rl.Vector2,
	Dir:    rl.Vector2,
	Size:   rl.Vector2,
	Speed:  f32,
	active: bool,
}
bullet_init :: proc(pos, target: rl.Vector2) -> Bullet {
	return Bullet {
		Pos = pos,
		Dir = linalg.vector_normalize0(target - pos),
		Size = {32, 32},
		Speed = 700,
		active = true,
	}
}

bullet_update :: proc(b: ^Bullet, dt: f32) {
	b.Pos += b.Dir * b.Speed * dt

	if b.Pos.x - b.Size.x / 2 <= 0 {
		b.active = false
	}
	if b.Pos.y - b.Size.y / 2 <= 0 {
		b.active = false
	}
	if b.Pos.x + b.Size.x / 2 >= f32(rl.GetScreenWidth()) {
		b.active = false
	}
	if b.Pos.y + b.Size.y / 2 >= f32(rl.GetScreenHeight()) {
		b.active = false
	}
}

bullet_draw :: proc(b: Bullet) {
	rl.DrawTexturePro(
		textures[.Bullet].texture,
		textures[.Bullet].source_rect,
		{
			b.Pos.x,
			b.Pos.y,
			textures[.Bullet].source_rect.width,
			textures[.Bullet].source_rect.height,
		},
		{textures[.Bullet].source_rect.width / 2, textures[.Bullet].source_rect.height / 2},
		0,
		rl.WHITE,
	)
}
