package main

import (
	"context"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jung-kurt/gofpdf"
)

func index(w http.ResponseWriter, r *http.Request) {
	t, err := template.ParseFiles("templates/index.html", "templates/header.html", "templates/footer.html")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	err = t.ExecuteTemplate(w, "index", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func generatePDF(w http.ResponseWriter, id int, convTime time.Time, amountIn, amountOut float64, currencyIn, currencyOut string) {
	pdf := gofpdf.New("P", "mm", "A4", "")
	pdf.AddPage()
	pdf.SetFont("Arial", "B", 16)
	pdf.Cell(40, 10, "Receipt")
	pdf.Ln(20)

	pdf.SetFont("Arial", "", 12)
	pdf.Cell(40, 10, fmt.Sprintf("Operation number: %d", id))
	pdf.Ln(10)
	pdf.Cell(40, 10, fmt.Sprintf("Conversion time: %s", convTime.Format("2006-01-02 15:04:05")))
	pdf.Ln(10)
	pdf.Cell(40, 10, fmt.Sprintf("Entry Amount: %.2f", amountIn))
	pdf.Ln(10)
	pdf.Cell(40, 10, fmt.Sprintf("Exit Amount: %.2f", amountOut))
	pdf.Ln(10)
	pdf.Cell(40, 10, fmt.Sprintf("Input Currency: %s", currencyIn))
	pdf.Ln(10)
	pdf.Cell(40, 10, fmt.Sprintf("Outgoing Currency: %s", currencyOut))

	err := pdf.Output(w)
	if err != nil {
		http.Error(w, fmt.Sprintf("Ошибка генерации PDF: %v", err), http.StatusInternalServerError)
	}
}

func save(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Метод должен быть POST", http.StatusMethodNotAllowed)
		return
	}

	inputCourseStr := r.FormValue("inputCourse")
	outputCourseStr := r.FormValue("outputCourse")
	take := r.FormValue("take")
	give := r.FormValue("give")

	inputCourse, err := strconv.ParseFloat(inputCourseStr, 64)
	if err != nil {
		http.Error(w, "Некорректное значение inputCourse", http.StatusBadRequest)
		return
	}

	outputCourse, err := strconv.ParseFloat(outputCourseStr, 64)
	if err != nil {
		http.Error(w, "Некорректное значение outputCourse", http.StatusBadRequest)
		return
	}

	connStr := "postgres://postgres:Googleapple123@localhost:5432/course"
	conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		http.Error(w, fmt.Sprintf("Ошибка подключения к БД: %v", err), http.StatusInternalServerError)
		return
	}
	defer conn.Close(context.Background())

	currentTime := time.Now()

	var id int
	err = conn.QueryRow(
		context.Background(),
		"INSERT INTO Convert (amount_in, amount_out, conv_time, currency_in, currency_out) VALUES ($1, $2, $3, $4, $5) RETURNING id",
		inputCourse,
		outputCourse,
		currentTime,
		take,
		give,
	).Scan(&id)
	if err != nil {
		http.Error(w, fmt.Sprintf("Ошибка выполнения запроса: %v", err), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/pdf")
	w.Header().Set("Content-Disposition", "inline; filename=\"receipt.pdf\"")

	generatePDF(w, id, currentTime, inputCourse, outputCourse, take, give)
}

func handleFunc() {
	http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("./static/"))))
	http.HandleFunc("/", index)
	http.HandleFunc("/save", save)
	fmt.Println("Server is listening: http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func main() {
	handleFunc()
}
