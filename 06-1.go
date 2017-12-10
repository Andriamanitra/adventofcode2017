package main

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"
)

// wrapping index
func wind(slc []int, i int) int {
	if i < 0 {
		return len(slc) - i
	} else if i >= len(slc) {
		return i % len(slc)
	} else {
		return i
	}
}

// returns string representation of integer slice
func strep(slc []int) string {
	var strslc []string
	for _, x := range slc {
		nStr := strconv.Itoa(x)
		strslc = append(strslc, nStr)
	}
	return strings.Join(strslc, ",")
}

func main() {
	// read the input to int slice (intSlice)
	f, err := ioutil.ReadFile("6-input.txt")
	if err != nil {
		fmt.Println("reading file failed:", err)
	}
	input := string(f)
	slc := strings.Split(input, "\t")
	var intSlice []int
	for _, x := range slc {
		n, err := strconv.Atoi(x)
		if err != nil {
			fmt.Println("Parsing int from string failed: ", err)
		}
		intSlice = append(intSlice, n)
	}

	// save the slices we've been to as set of string representations or smth
	// ...except go-lang doesn't have sets so we'll use map
	beentheredonethat := make(map[string]bool)
	redistcycles := 0
	for {
		_, beenthere := beentheredonethat[strep(intSlice)]
		if beenthere {
			break
		}
		beentheredonethat[strep(intSlice)] = true

		// find the index of largest element
		maxValue := intSlice[0]
		indexOfMax := 0
		for i, x := range intSlice {
			if x > maxValue {
				maxValue = x
				indexOfMax = i
			}
		}

		// distribute the largest element
		intSlice[indexOfMax] = 0
		for i := indexOfMax + 1; maxValue > 0; maxValue-- {
			intSlice[wind(intSlice, i)] = intSlice[wind(intSlice, i)] + 1
			i++
		}

		redistcycles++
	}
	fmt.Println("Cycles until repeating:", redistcycles)
}
