package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strconv"
)

func main() {
    fmt.Println("Hello, World!")
    
    // open file
    file, err := os.Open("input.txt")
    if err != nil {
    	log.Fatal(err)
    }

    defer file.Close()

    // read file
    var lines = []int64{}
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
    	line, _ := strconv.ParseInt(scanner.Text(), 10, 64)
    	lines = append(lines, line)
    }

    // part 1
    fmt.Println("Part 1:")
    var found = false
	for i, v := range lines {
		if found {
			break
		}
		for i2, v2 := range lines {
			if found {
				break
			}
			if i != i2 {
				if (v + v2) == 2020 {
					// fmt.Println(i, v, "|", i2, v2)
					fmt.Println(v * v2)
					found = true
				}
			}
		}
	}

    // part 2
    fmt.Println("Part 2:")
    var found2 = false
	for i1, v1 := range lines {
		if found2 { break }
		for i2, v2 := range lines {
			if found2 { break }
			for i3, v3 := range lines {
				if found2 { break }

				if i1 != i2 && i1 != i3 {
					if (v1 + v2 + v3) == 2020 {
						fmt.Println(v1 * v2 * v3)
						found2 = true
					}
				}
			}
		}
	}

    if err := scanner.Err(); err != nil {
    	log.Fatal(err)
    }
}
