package aoc_four

import "core:bytes"
import "core:fmt"
import "core:math"
import "core:os"
import "core:slice"
import "core:strconv"


parse_numbers_from_list :: proc(list: []u8) -> (result: [dynamic]int) {
	numbers := bytes.split(list, []u8{' '})
	for number in numbers {
		// Handle split with single digit numbers
		if len(number) == 0 {
			continue
		} else {
			append(&result, strconv.atoi(string(bytes.trim_space(number))))
		}
	}
	return result
}

// Don't really need to return the intersection, but..
intersection :: proc(list_one: []int, list_two: []int) -> (result: [dynamic]int) {
	for i in list_one {
		if slice.contains(list_two, i) {
			append(&result, i)
		}
	}
	return result
}


card_points :: proc() {
	total := 0
	data, ok := os.read_entire_file_from_filename("input.txt")
	if !ok {
		fmt.println("Failed to read input.txt")
		return
	}

	points: int

	lines := bytes.split(data, transmute([]u8)(string("\n")))
	for i in 0 ..< len(lines) {
		if len(lines[i]) > 0 {
			card_info := bytes.split_n(lines[i], []u8{':', ' '}, 2)
			card_numbers := bytes.split_n(card_info[1], []u8{' ', '|', ' '}, 2)
			winning_numbers := parse_numbers_from_list(card_numbers[0])
			my_numbers := parse_numbers_from_list(card_numbers[1])
			my_winning_numbers := intersection(winning_numbers[:], my_numbers[:])
			if len(my_winning_numbers) > 0 {
				card_points := 1 << uint(len(my_winning_numbers) - 1)
				points += card_points
			}
		}
	}
	fmt.printf("Total card points is: %d\n", points)
}

scratch_cards :: proc() {
	//piles: [dynamic]int
	data, ok := os.read_entire_file_from_filename("input.txt")
	if !ok {
		fmt.println("Failed to read input.txt")
		return
	}

	lines := bytes.split(data, transmute([]u8)(string("\n")))
	piles := make([dynamic]int, len(lines) - 1)
	for i in 0 ..< len(lines) {
		if len(lines[i]) > 0 {
			piles[i] += 1
			card_info := bytes.split_n(lines[i], []u8{':', ' '}, 2)
			card_numbers := bytes.split_n(card_info[1], []u8{' ', '|', ' '}, 2)
			winning_numbers := parse_numbers_from_list(card_numbers[0])
			my_numbers := parse_numbers_from_list(card_numbers[1])
			my_winning_numbers := intersection(winning_numbers[:], my_numbers[:])
			for pile in 0 ..< piles[i] {
				for j in 0 ..< len(my_winning_numbers) {
					piles[i + j + 1] += 1
				}
			}
		}
	}
	fmt.printf("Total scratch cards is: %d\n", math.sum(piles[:]))
}

main :: proc() {
	card_points()
	scratch_cards()
}
