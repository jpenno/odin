package game

import "core:c"
import rl "vendor:raylib"

textures: [Texture_Name]Texture

Texture_Name :: enum {
	None,
	Player,
}

Texture :: struct {
	texture:     rl.Texture,
	source_rect: rl.Rectangle,
}

init_textures :: proc() {
	textures[.Player] = init_texture("assets/spaceship.png")
}

@(private = "file")
init_texture :: proc(file_path: string) -> (texture: Texture) {
	// A different way of loading a texture: using `read_entire_file` that works
	// both on desktop and web. Note: You can import `core:os` and use
	// `os.read_entire_file`. But that won't work on web. Emscripten has a way
	// to bundle files into the build, and we access those using this
	// special `read_entire_file`.
	if data, ok := read_entire_file(file_path, context.temp_allocator); ok {
		img := rl.LoadImageFromMemory(".png", raw_data(data), c.int(len(data)))
		texture.texture = rl.LoadTextureFromImage(img)
		texture.source_rect = {0, 0, f32(texture.texture.width), f32(texture.texture.height)}
		rl.UnloadImage(img)
	}
	return texture
}
