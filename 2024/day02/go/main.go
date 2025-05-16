package main

import (
	"bufio"
	"fmt"
	"log"
	"math"
	"os"
	"strconv"
	"strings"
)

func main() {
	fmt.Println("Part 1: ", part1("data.txt"))
	fmt.Println("Part 2: ", part2("data.txt"))
}

type data struct {
	str     string
	buf     int
	pos     bool
	safe    bool
	first   bool // first passthrough
	warning bool
	line    []int
}

func part1(filename string) int {
	file, err := os.Open(filename)
	defer file.Close()
	if err != nil {
		log.Fatalf("Error: %s", err)
	}

	total := 0

	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)
	for scanner.Scan() {
		line := scanner.Text() + " "

		if len(line) < 1 {
			log.Fatalln("Invalid input")
		}

		d := data{
			str:   "",
			buf:   -1,
			pos:   true,
			safe:  true,
			first: true,
		}

		for _, n := range line {
			if string(n) == " " {
				num, err := strconv.Atoi(d.str)
				if err != nil {
					log.Fatalf("Error: %s", err)
				}

				if d.buf == -1 {
					d.buf = num
				} else {
					val := d.buf - num

					if d.first {
						d.first = false
						if val < 0 {
							d.pos = false
						}
					}

					if (val < 0 && d.pos) || (val > 0 && !d.pos) || math.Abs(float64(val)) < 1 || math.Abs(float64(val)) > 3 {
						// line is unsafe
						d.safe = false
						break
					}

					// current number is safe
					d.buf = num
				}
				d.str = ""
			} else {
				d.str += string(n)
			}
		}

		if d.safe {
			total += 1
		}
	}
	return total
}

func part2(filename string) int {
	file, err := os.Open(filename)
	defer file.Close()
	if err != nil {
		log.Fatalf("Error: %s", err)
	}

	total := 0

	scanner := bufio.NewScanner(file)
	scanner.Split(bufio.ScanLines)
	for scanner.Scan() {
		lineStr := strings.Split(scanner.Text(), " ")
		if len(lineStr) < 1 {
			log.Fatalln("Invalid input")
		}
		var line []int
		for _, n := range lineStr {
			num, err := strconv.Atoi(n)
			if err != nil {
				log.Fatalf("Error: %s", err)
			}
			line = append(line, num)
		}

		checkSafe := func(row []int) bool {
			pos := true
			first := true

			for j := range row[:len(row)-1] {
				val := row[j] - row[j+1]
				if first {
					first = false
					if val < 0 {
						pos = false
					}
				}

				if (val < 0 && pos) || (val > 0 && !pos) || math.Abs(float64(val)) < 1 || math.Abs(float64(val)) > 3 {
					return false
				}
			}
			return true
		}

		if checkSafe(line) {
			total += 1
			continue
		}

		for i := range line {
			dest1 := make([]int, len(line[:i]))
			dest2 := make([]int, len(line[i+1:]))
			copy(dest1, line[:i])
			copy(dest2, line[i+1:])
			row := append(dest1, dest2...)
			if checkSafe(row) {
				total += 1
				break
			}
		}

	}
	return total
}
