package aoc_two

import "core:bytes"
import "core:fmt"
import "core:os"
import "core:strconv"

Game :: struct {
	number: int,
	valid:  bool,
}

main :: proc() {
	total := 0
	data, ok := os.read_entire_file_from_filename("input.txt")
	if !ok {
		fmt.println("Failed to read input.txt")
		return
	}

	total_of_valid_game_ids: int

	lines := bytes.split(data, transmute([]u8)(string("\n")))
	for i in 0 ..< len(lines) {
		if len(lines[i]) > 0 {
			game_info := bytes.split_n(lines[i], []u8{':', ' '}, 2)
			game_header := bytes.split_n(game_info[0], []u8{' '}, 2)
			game := Game{strconv.atoi(string(game_header[1])), true}
			handfuls := bytes.split(game_info[1], []u8{';', ' '})
			for handful in handfuls {
				cubes := bytes.split(handful, []u8{',', ' '})
				for cube in cubes {
					count_and_color := bytes.split_n(cube, []u8{' '}, 2)
					count := string(count_and_color[0])
					color := count_and_color[1]
					switch string(color) {
					case "red":
						if strconv.atoi(count) > 12 {
							game.valid = false
						}
					case "blue":
						if strconv.atoi(count) > 14 {
							game.valid = false
						}
					case "green":
						if strconv.atoi(count) > 13 {
							game.valid = false
						}
					}
				}
			}
			if game.valid {
				total_of_valid_game_ids += game.number
			}
		}
	}

	fmt.printf("Total is: %d\n", total_of_valid_game_ids)
}
