package main

import (
	"testing"
)

func TestPart1(t *testing.T) {
	t.Run("Part 1", func(t *testing.T) {
		expected := 11
		actual := part1("test.txt")
		if expected != actual {
			t.Fatalf("Expected: %d\nActual: %d\n", expected, actual)
		}
	})
}

func TestPart2(t *testing.T) {
	t.Run("Part 2", func(t *testing.T) {
		expected := 31
		actual := part2("test.txt")
		if expected != actual {
			t.Fatalf("Expected: %d\nActual: %d\n", expected, actual)
		}
	})
}
