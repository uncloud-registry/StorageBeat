package main

import (
	"encoding/csv"
	"html/template"
	"os"
)

type PageData struct {
	Title     string
	TableData [][]string
	Headings  []string
}

func main() {
	// Read data from the CSV file
	csvFile, err := os.Open("../data/storage.csv")
	if err != nil {
		panic(err)
	}
	defer csvFile.Close()

	// Parse the CSV file
	csvReader := csv.NewReader(csvFile)
	records, err := csvReader.ReadAll()
	if err != nil {
		panic(err)
	}

	headings := records[0]
	records = records[1:]

	// Define the data to be passed into the template
	data := PageData{
		Title:     "StorageBeat",
		TableData: records,
		Headings:  headings,
	}

	// Parse the template file
	tmpl, err := template.ParseFiles("templates/index.tmpl")
	if err != nil {
		panic(err)
	}

	// Create the output directory if it doesn't exist
	if err := os.MkdirAll("out", os.ModePerm); err != nil {
		panic(err)
	}

	// Create the output file
	outputFile, err := os.Create("out/index.html")
	if err != nil {
		panic(err)
	}
	defer outputFile.Close()

	// Execute the template with the data and write the output to the file
	if err := tmpl.Execute(outputFile, data); err != nil {
		panic(err)
	}

	println("Template compiled successfully and saved to out/index.html")

}
