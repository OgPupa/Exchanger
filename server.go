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

	currentTime := time.Now() // получение текущего времени

	_, err = conn.Exec(
		context.Background(),
		"INSERT INTO Convert (amount_in, amount_out, conv_time, currency_in, currency_out) VALUES ($1, $2, $3, $4, $5)",
		inputCourse,
		outputCourse,
		currentTime,
		take,
		give,
	)
	if err != nil {
		http.Error(w, fmt.Sprintf("Ошибка выполнения запроса: %v", err), http.StatusInternalServerError)
		return
	}

	http.Redirect(w, r, "/", http.StatusSeeOther)
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
