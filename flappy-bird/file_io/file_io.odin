package file_io

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

get_highscores :: proc(filepath: string) -> (highscores: [10]int) {
	data, ok := os.read_entire_file(filepath)
	if !ok {
		fmt.printfln("error loading file: %q", filepath)
		return
	}
	defer delete(data)

	it := string(data)
	i: int
	for line in strings.split_lines_iterator(&it) {
		highscores[i] = strconv.atoi(line)
		i += 1
	}

	slice.reverse_sort(highscores[:])

	return highscores
}

save_highscores :: proc(filepath: string, highscores: [10]int) {
	tmp := [10]string{}

	buf: [4]byte
	for score, i in highscores {
		tmp[i] = strings.clone(strconv.itoa(buf[:], score))
	}

	data_as_string := strings.join(tmp[:], "\n")
	data_as_bytes := transmute([]byte)(data_as_string)
	os.write_entire_file(filepath, data_as_bytes)
}
