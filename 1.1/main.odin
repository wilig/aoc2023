package aoc_one_part_two

import "core:bytes"
import "core:fmt"
import "core:os"


make_number_map :: proc() -> map[string]int {
	numbers := make(map[string]int)
	numbers["0"] = 0
	numbers["1"] = 1
	numbers["one"] = 1
	numbers["2"] = 2
	numbers["two"] = 2
	numbers["3"] = 3
	numbers["three"] = 3
	numbers["4"] = 4
	numbers["four"] = 4
	numbers["5"] = 5
	numbers["five"] = 5
	numbers["6"] = 6
	numbers["six"] = 6
	numbers["7"] = 7
	numbers["seven"] = 7
	numbers["8"] = 8
	numbers["eight"] = 8
	numbers["9"] = 9
	numbers["nine"] = 9
	return numbers
}


first_number :: proc(data: []u8, numbers: map[string]int) -> int {
	value := 0
	lowest_offset := len(data)
	for k in numbers {
		offset := bytes.index(data, transmute([]u8)k)
		if offset > -1 && offset < lowest_offset {
			value = numbers[k]
			lowest_offset = offset
		}
	}

	return value
}

last_number :: proc(data: []u8, numbers: map[string]int) -> int {
	value := 0
	highest_offset := -1
	for k in numbers {
		offset := bytes.last_index(data, transmute([]u8)k)
		if offset > -1 && offset > highest_offset {
			value = numbers[k]
			highest_offset = offset
		}
	}
	return value
}

main :: proc() {
	numbers := make_number_map()
	total := 0
	data, ok := os.read_entire_file_from_filename("input.txt")
	if !ok {
		fmt.println("Failed to read input.txt")
		return
	}
	lines := bytes.split(data, transmute([]u8)(string("\n")))
	for i in 0 ..< len(lines) {
		if len(lines[i]) > 0 {
			line_total := first_number(lines[i], numbers) * 10 + last_number(lines[i], numbers)
			fmt.printf("line: %d, number: %d\n", i + 1, line_total)
			total += line_total
		}
	}

	fmt.printf("Total is: %d\n", total)
}
