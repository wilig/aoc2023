package aoc_one

import "core:bytes"
import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"


is_digit :: proc(c: u8) -> bool {
	return c >= '0' && c <= '9'
}

parse_part_number :: proc(line: []u8, col: int) -> (part_number: int, success: bool) {
	digits: [dynamic]int
	part_number_length := 0
	start := col

	// Find the start of the part number
	for (start > 0 && is_digit(line[start - 1])) {
		start -= 1
	}

	// Now find the length of the part number
	for len(line) > start + part_number_length && is_digit(line[start + part_number_length]) {
		part_number_length += 1
	}

	part_number = strconv.parse_int(string(line[start:start + part_number_length])) or_return

	return part_number, true
}

find_part_numbers :: proc(lines: [][]u8, row: int, col: int) -> [dynamic]int {
	part_numbers: [dynamic]int
	for y in row - 1 ..= row + 1 {
		for x in col - 1 ..= col + 1 {
			if is_digit(lines[y][x]) {
				part_number, ok := parse_part_number(lines[y], x)
				// Assumes that part numbers are distinct per symbol
				if ok {
					if !slice.contains(part_numbers[:], part_number) {
						append(&part_numbers, part_number)
					}
				} else {
					fmt.println("Failed to parse a part number!")
				}
			}
		}
	}
	return part_numbers
}


main :: proc() {
	total := 0
	data, ok := os.read_entire_file_from_filename("input.txt")
	if !ok {
		fmt.println("Failed to read input.txt")
		return
	}

	lines := bytes.split(data, transmute([]u8)(string("\n")))
	for row in 0 ..< len(lines) {
		for col in 0 ..< len(lines[row]) {
			if lines[row][col] == u8('*') {
				part_nos := find_part_numbers(lines, row, col)
				if len(part_nos) == 2 {
					total += part_nos[0] * part_nos[1]
				}
			}
		}
	}

	fmt.printf("Total is: %d\n", total)
}
