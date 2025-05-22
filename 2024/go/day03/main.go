package main

import (
	"fmt"
	"log"
	"os"
	"regexp"
	"strconv"
)

func main() {
	fmt.Println("Part 1: ", part1("data.txt"))
	fmt.Println("Part 2: ", part2("data.txt"))
}

func logErr(err error) {
	if err != nil {
		log.Fatalln("Error: ", err)
	}
}

func part1(filename string) int {
	data, err := os.ReadFile(filename)
	logErr(err)

	str := string(data)

	r, err := regexp.Compile(`mul\(\d{1,3},\d{1,3}\)`)
	logErr(err)

	lists := r.FindAllString(str, -1)

	total := 0
	for _, n := range lists {
		rInt, err := regexp.Compile(`\d{1,3}`)
		logErr(err)

		nums := rInt.FindAllString(n, 2)
		a, err := strconv.Atoi(nums[0])
		logErr(err)
		b, err := strconv.Atoi(nums[1])
		logErr(err)

		total += (a * b)
	}

	return total
}

func part2(filename string) int {
	data, err := os.ReadFile(filename)
	logErr(err)

	str := "do()" + string(data) + "do()"

	r, err := regexp.Compile(`(do\(\))|(don't\(\))`)
	logErr(err)
	idx := r.FindAllStringIndex(str, -1)

	total := 0
	for i, n := range idx[:len(idx)-1] {
		var newStr string
		if n[1]-n[0] == 4 {
			newStr = str[n[0]:idx[i+1][0]]
		}

		mulInt, err := regexp.Compile(`mul\(\d{1,3},\d{1,3}\)`)
		logErr(err)

		rInt, err := regexp.Compile(`\d{1,3}`)
		logErr(err)

		muls := mulInt.FindAllString(newStr, -1)
		for _, x := range muls {
			nums := rInt.FindAllString(x, 2)
			a, err := strconv.Atoi(nums[0])
			logErr(err)
			b, err := strconv.Atoi(nums[1])
			logErr(err)

			total += (a * b)
		}
	}
	return total
}
