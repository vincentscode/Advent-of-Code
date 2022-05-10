package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strings"
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
    var lines = []string{}
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
    	line := scanner.Text()
    	lines = append(lines, line)
    }

    if err := scanner.Err(); err != nil {
    	log.Fatal(err)
    }

    var counter1 = 0
    var counter2 = 0
	for _, v := range lines {
		s := strings.Split(v, " ")

		numRange := strings.Split(s[0], "-")
		numLow, _ := strconv.Atoi(numRange[0])
		numHigh, _ := strconv.Atoi(numRange[1])

		character := strings.ReplaceAll(s[1], ":", "")

		password := s[2]

		count := strings.Count(password, character)

    	// fmt.Println(numLow, numHigh, character, password, "|", count)
    	if numLow <= count && count <= numHigh {
    		counter1 += 1
    	}

    	fmt.Println(len(password))
    	
    	X := string(password[numLow+1]) == character
    	Y := string(password[numHigh+1]) == character
    	if (X || Y) && !(X && Y) {
    		counter2 += 1
    	}
	}

    fmt.Println(counter1, "|", counter2)
}
