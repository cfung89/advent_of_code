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

// Min-Heap implementation
type Heap []int

func (heap *Heap) Insert(num int) {
	*heap = append(*heap, num)
	index := len(*heap) - 1
	for index > 0 && (*heap)[(index-1)/2] > (*heap)[index] {
		(*heap)[(index-1)/2], (*heap)[index] = (*heap)[index], (*heap)[(index-1)/2]
		index = (index - 1) / 2
	}
	return
}

func (heap *Heap) Remove() float64 {
	if len(*heap) == 0 {
		log.Fatalln("Error: Heap of length 0")
	}

	index := 0
	val := float64((*heap)[index])
	(*heap)[index] = (*heap)[len(*heap)-1]
	*heap = (*heap)[:len(*heap)-1]

	for {
		left, right := 2*index+1, 2*index+2
		smallest := index
		length := len(*heap)

		if left < length && (*heap)[left] < (*heap)[smallest] {
			smallest = left
		}
		if right < length && (*heap)[right] < (*heap)[smallest] {
			smallest = right
		}
		if smallest != index {
			(*heap)[smallest], (*heap)[index] = (*heap)[index], (*heap)[smallest]
			index = smallest
		} else {
			break
		}
	}
	return val
}

// AOC - Problem 1, Part 1
func part1(filename string) int {
	heap1, heap2 := &Heap{}, &Heap{}
	readFile := func(filename string, heap1 *Heap, heap2 *Heap) {
		file, err := os.Open(filename)
		defer file.Close()
		if err != nil {
			log.Fatalf("Error: %s", err)
		}

		scanner := bufio.NewScanner(file)
		scanner.Split(bufio.ScanLines)
		for scanner.Scan() {
			temp := strings.Split(scanner.Text(), "   ")

			a, errA := strconv.Atoi(temp[0])
			if errA != nil {
				log.Fatalf("Error: %s", errA)
			}

			b, errB := strconv.Atoi(temp[1])
			if errB != nil {
				log.Fatalf("Error: %s", errB)
			}

			heap1.Insert(a)
			heap2.Insert(b)
		}
	}

	readFile(filename, heap1, heap2)
	if len(*heap1) != len(*heap2) {
		log.Fatalln("Error: Lengths of heap1 and heap2 are not the same.")
	}

	var sum float64 = 0
	for range *heap1 {
		sum += math.Abs(heap1.Remove() - heap2.Remove())
	}

	return int(sum)
}

func part2(filename string) int {
	readFile := func(filename string) ([]int, map[int]int) {
		file, err := os.Open(filename)
		defer file.Close()
		if err != nil {
			log.Fatalf("Error %s", err)
		}

		scanner := bufio.NewScanner(file)
		scanner.Split(bufio.ScanLines)
		arr := make([]int, 0)
		dict := make(map[int]int)

		for scanner.Scan() {
			temp := strings.Split(scanner.Text(), "   ")

			a, errA := strconv.Atoi(temp[0])
			if errA != nil {
				log.Fatalf("Error: %s", errA)
			}

			b, errB := strconv.Atoi(temp[1])
			if errB != nil {
				log.Fatalf("Error: %s", errB)
			}

			arr = append(arr, a)

			if _, ok := dict[b]; ok {
				dict[b] += 1
			} else {
				dict[b] = 1
			}
		}

		return arr, dict
	}
	arr, dict := readFile(filename)

	sum := 0
	for _, n := range arr {
		if val, ok := dict[n]; ok {
			sum += n * val
		}
	}

	return sum
}
