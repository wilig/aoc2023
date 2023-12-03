package aoc_one

import "core:bytes"
import "core:fmt"
import "core:os"
import "core:strconv"

Game :: struct {
	number:          int,
	max_red_cubes:   int,
	max_blue_cubes:  int,
	max_green_cubes: int,
}

main :: proc() {
	total := 0
	data, ok := os.read_entire_file_from_filename("input.txt")
	if !ok {
		fmt.println("Failed to read input.txt")
		return
	}

	sum_of_power: int

	lines := bytes.split(data, transmute([]u8)(string("\n")))
	for i in 0 ..< len(lines) {
		if len(lines[i]) > 0 {
			game := Game{}
			game_info := bytes.split_n(lines[i], []u8{':', ' '}, 2)
			game_header := bytes.split_n(game_info[0], []u8{' '}, 2)
			game.number = strconv.atoi(string(game_header[1]))
			handfuls := bytes.split(game_info[1], []u8{';', ' '})
			for handful in handfuls {
				cubes := bytes.split(handful, []u8{',', ' '})
				for cube in cubes {
					count_and_color := bytes.split_n(cube, []u8{' '}, 2)
					count := strconv.atoi(string(count_and_color[0]))
					color := count_and_color[1]
					switch string(color) {
					case "red":
						if count > game.max_red_cubes {
							game.max_red_cubes = count
						}
					case "blue":
						if count > game.max_blue_cubes {
							game.max_blue_cubes = count
						}
					case "green":
						if count > game.max_green_cubes {
							game.max_green_cubes = count
						}
					}
				}
			}
			sum_of_power += game.max_red_cubes * game.max_blue_cubes * game.max_green_cubes
		}
	}

	fmt.printf("Total is: %d\n", sum_of_power)
}
