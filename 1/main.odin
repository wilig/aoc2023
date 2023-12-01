package aoc_one

import "core:bytes"
import "core:fmt"
import "core:os"

first_number :: proc(data: []u8) -> int {
	for i in 0 ..< len(data) {
		val := cast(int)data[i] - 48
		if val >= 0 && val <= 9 {
			return val
		}
	}
	return 0
}

last_number :: proc(data: []u8) -> int {
	for i := len(data) - 1; i > -1; i -= 1 {
		val := cast(int)data[i] - 48
		if val >= 0 && val <= 9 {
			return val
		}
	}
	return 0
}

main :: proc() {
	total := 0
	data, ok := os.read_entire_file_from_filename("input.txt")
	if !ok {
		fmt.println("Failed to read input.txt")
		return
	}
	lines := bytes.split(data, transmute([]u8)(string("\n")))
	for i in 0 ..< len(lines) {
		if len(lines[i]) > 0 {
			line_total := first_number(lines[i]) * 10 + last_number(lines[i])
			fmt.printf("line_total: %d\n", line_total)
			total += line_total
		}
	}

	fmt.printf("Total is: %d\n", total)
}
