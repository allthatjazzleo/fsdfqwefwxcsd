package main

import (
	"bufio"
	"fmt"
	geoip2 "github.com/oschwald/geoip2-golang"
	"log"
	"net"
	"os"
	"regexp"
	"sort"
	"strings"
)

func main() {
	// open file and take arg
	arg := os.Args[1]
	dir, err := os.Getwd()
	if err != nil {
		log.Fatal(err)
	}
	file, _ := os.Open(fmt.Sprintf("%s/%s", dir, arg))

	// declare map for counting most hosts requested
	ip := make(map[string]int)

	// execute count line function
	countLine(file, ip)

	// sort top ten IP
	sortTopIP(10, ip)

	// sort the most request country
	arg2 := os.Args[2]
	mmdbFile := fmt.Sprintf("%s/%s", dir, arg2)
	sortTopRequestCountry(1, ip, mmdbFile)
}

func countLine(file *os.File, ip map[string]int) {

	scanner := bufio.NewScanner(file)

	// Set the split function for the scanning operation.
	scanner.Split(bufio.ScanLines)

	// Count the lines.
	count := 0
	for scanner.Scan() {
		count++
		parseIPAndCount(scanner.Text(), ip)
	}

	if err := scanner.Err(); err != nil {
		fmt.Fprintln(os.Stderr, "reading input:", err)
	}

	fmt.Printf("Total no of records in access.log are %d\n\n", count)
}

func parseIPAndCount(line string, ip map[string]int) {
	// parse IP regex
	r, _ := regexp.Compile("([0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+) - -")
	if match := r.FindStringSubmatch(line); len(match) != 0 {
		ip[strings.TrimSuffix(fmt.Sprintln(match[1]), "\n")]++
	}
}

func sortTopIP(i int, ip map[string]int) {
	type kv struct {
		Key   string
		Value int
	}
	var ss []kv
	// parse map to struct
	for k, v := range ip {
		ss = append(ss, kv{k, v})
	}
	// sort ip by value
	sort.Slice(ss, func(i, j int) bool {
		return ss[i].Value > ss[j].Value
	})
	fmt.Printf("Top %v hosts:\n", i)
	for num, kv := range ss[:i] {
		fmt.Printf("%d: %s with %d requests\n", num+1, kv.Key, kv.Value)
	}
}

func sortTopRequestCountry(i int, ip map[string]int, mmdbFile string) {
	countryMap := make(map[string]int)
	db, err := geoip2.Open(mmdbFile)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// check ip country and accum
	for k, _ := range ip {
		IP := net.ParseIP(k)
		record, err := db.Country(IP)
		if err != nil {
			log.Fatal(err)
		}
		if country := record.Country.Names["en"]; len(country) != 0 {
			countryMap[country]++
		}
	}

	// get the top country by sorting
	type kv struct {
		Key   string
		Value int
	}
	var ss []kv
	for k, v := range countryMap {
		ss = append(ss, kv{k, v})
	}
	sort.Slice(ss, func(i, j int) bool {
		return ss[i].Value > ss[j].Value
	})
	fmt.Printf("\nTop %v country requests from:\n", i)
	for num, kv := range ss[:i] {
		fmt.Printf("%d: %s with %d requests\n", num+1, kv.Key, kv.Value)
	}
}
