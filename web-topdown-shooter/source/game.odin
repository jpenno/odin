package game

import "core:c"
import "core:fmt"
import "core:log"
import "core:math"
import rl "vendor:raylib"


run: bool
textures: [Texture_Name]Texture
texture: rl.Texture
texture2: rl.Texture
texture2_rot: f32

player: Player

init :: proc() {
	run = true
	rl.SetConfigFlags({.WINDOW_RESIZABLE, .VSYNC_HINT})
	rl.InitWindow(1280, 720, "Odin + Raylib on the web")

	// Anything in `assets` folder is available to load.
	texture = rl.LoadTexture("assets/round_cat.png")

	// A different way of loading a texture: using `read_entire_file` that works
	// both on desktop and web. Note: You can import `core:os` and use
	// `os.read_entire_file`. But that won't work on web. Emscripten has a way
	// to bundle files into the build, and we access those using this
	// special `read_entire_file`.
	if long_cat_data, long_cat_ok := read_entire_file(
		"assets/long_cat.png",
		context.temp_allocator,
	); long_cat_ok {
		long_cat_img := rl.LoadImageFromMemory(
			".png",
			raw_data(long_cat_data),
			c.int(len(long_cat_data)),
		)
		texture2 = rl.LoadTextureFromImage(long_cat_img)
		rl.UnloadImage(long_cat_img)
	}

	init_textures()

	player = Player {
		Pos   = {300, 300},
		speed = 500,
	}

}

update :: proc() {
	dt := rl.GetFrameTime()
	player_update(&player, dt)

	draw()
	// Anything allocated using temp allocator is invalid after this.
	free_all(context.temp_allocator)
}

draw :: proc() {
	rl.BeginDrawing()
	rl.ClearBackground(rl.GRAY)
	texture2_rot += rl.GetFrameTime() * 50
	source_rect := rl.Rectangle{0, 0, f32(texture2.width), f32(texture2.height)}
	dest_rect := rl.Rectangle{300, 220, f32(texture2.width) * 5, f32(texture2.height) * 5}

	x: f64 = f64(player.Pos.x) - f64(rl.GetMouseX())
	y: f64 = f64(player.Pos.y) - f64(rl.GetMouseY())
	rotation := math.atan2(x, y) * -57.29578 // Multiplies the angle by -57.295 to convert to degrees

	rl.DrawTexturePro(
		textures[.Player].texture,
		textures[.Player].source_rect,
		{
			player.Pos.x,
			player.Pos.y,
			textures[.Player].source_rect.width,
			textures[.Player].source_rect.height,
		},
		{textures[.Player].source_rect.width / 2, textures[.Player].source_rect.height / 2},
		f32(rotation),
		rl.WHITE,
	)

	rl.EndDrawing()
}

// In a web build, this is called when browser changes size. Remove the
// `rl.SetWindowSize` call if you don't want a resizable game.
parent_window_size_changed :: proc(w, h: int) {
	rl.SetWindowSize(c.int(w), c.int(h))
}

shutdown :: proc() {
	rl.CloseWindow()
}

should_run :: proc() -> bool {
	when ODIN_OS != .JS {
		// Never run this proc in browser. It contains a 16 ms sleep on web!
		if rl.WindowShouldClose() {
			run = false
		}
	}

	return run
}
