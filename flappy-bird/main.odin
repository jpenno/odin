package flappy_bird

import "app"
import "core:fmt"
import rl "vendor:raylib"

SCREEN_WIDTH :: 720
SCREEN_HEIGHT :: 1080

main :: proc() {
	app.Init(SCREEN_WIDTH, SCREEN_HEIGHT)
	app.Run()
	app.Quit()
}
