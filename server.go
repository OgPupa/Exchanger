package main

import (
	"context"
	"crypto/sha256"
	"encoding/gob"
	"encoding/hex"
	"fmt"
	"html/template"
	"log"
	"net/http"
	"strconv"
	"time"

	"github.com/gorilla/sessions"
	"github.com/jackc/pgx/v5"
	"github.com/jung-kurt/gofpdf"
)

var store = sessions.NewCookieStore([]byte("something-very-secret"))

func init() {
	gob.Register(time.Time{})
}

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

func reg(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodPost {
		middleName := r.FormValue("middleName")
		firstName := r.FormValue("firstName")
		lastName := r.FormValue("lastName")
		email := r.FormValue("email")
		gender := r.FormValue("gender")
		birthDate := r.FormValue("birthDate")
		passport := r.FormValue("passport")
		password := r.FormValue("password")
		confirmPassword := r.FormValue("confirmPassword")

		if password != confirmPassword {
			http.Error(w, "Пароли не совпадают", http.StatusBadRequest)
			return
		}

		// Проверяем правильность даты рождения
		userBirthDate, err := time.Parse("2006-01-02", birthDate)
		if err != nil {
			http.Error(w, "Неправильный формат даты рождения", http.StatusBadRequest)
			return
		}

		// Проверяем, что пользователю более 18 лет
		if !isOlderThan18(userBirthDate) {
			http.Error(w, "Вам должно быть не менее 18 лет для регистрации", http.StatusBadRequest)
			return
		}

		// Хэширование пароля для безопасности
		passwordHash := sha256.Sum256([]byte(password))
		passwordHashStr := hex.EncodeToString(passwordHash[:])

		connStr := "postgres://postgres:Googleapple123@localhost:5432/course"
		conn, err := pgx.Connect(context.Background(), connStr)
		if err != nil {
			http.Error(w, fmt.Sprintf("Ошибка подключения к БД: %v", err), http.StatusInternalServerError)
			return
		}
		defer conn.Close(context.Background())

		_, err = conn.Exec(
			context.Background(),
			"INSERT INTO lk (user_surname, user_name, user_middlename, user_email, male, date_of_birth, passport_data, user_password) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)",
			lastName, firstName, middleName, email, gender, birthDate, passport, passwordHashStr,
		)
		if err != nil {
			http.Error(w, fmt.Sprintf("Ошибка выполнения запроса: %v", err), http.StatusInternalServerError)
			return
		}

		http.Redirect(w, r, "/login", http.StatusFound)
		return
	}

	t, err := template.ParseFiles("templates/reg.html", "templates/header.html", "templates/footer.html")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	err = t.ExecuteTemplate(w, "reg", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

// Функция для проверки возраста
func isOlderThan18(birthDate time.Time) bool {
	now := time.Now()
	age := now.Year() - birthDate.Year()
	if now.Month() < birthDate.Month() || (now.Month() == birthDate.Month() && now.Day() < birthDate.Day()) {
		age--
	}
	return age >= 18
}

func login(w http.ResponseWriter, r *http.Request) {
	if r.Method == http.MethodPost {
		// Получение данных из формы
		email := r.FormValue("email")
		password := r.FormValue("password")

		// Хэширование пароля для сравнения
		passwordHash := sha256.Sum256([]byte(password))
		passwordHashStr := hex.EncodeToString(passwordHash[:])

		// Подключение к базе данных
		connStr := "postgres://postgres:Googleapple123@localhost:5432/course"
		conn, err := pgx.Connect(context.Background(), connStr)
		if err != nil {
			http.Error(w, fmt.Sprintf("Ошибка подключения к БД: %v", err), http.StatusInternalServerError)
			log.Printf("Ошибка подключения к БД: %v", err)
			return
		}
		defer conn.Close(context.Background())

		// Запрос к базе данных для проверки пользователя
		var storedPassword string
		err = conn.QueryRow(context.Background(), "SELECT user_password FROM lk WHERE user_email=$1", email).Scan(&storedPassword)
		if err != nil {
			http.Error(w, "Неверный логин или пароль", http.StatusUnauthorized)
			log.Printf("Ошибка SQL запроса или пользователь не найден: %v", err)
			return
		}

		// Сравнение хэшей паролей
		if storedPassword != passwordHashStr {
			http.Error(w, "Неверный логин или пароль", http.StatusUnauthorized)
			log.Println("Пароль не совпадает.")
			return
		}

		// Запрос дополнительных данных пользователя
		var userName, userSurname, userMiddlename, userEmail, male, passportData string
		var dateOfBirth time.Time
		err = conn.QueryRow(context.Background(), "SELECT user_name, user_surname, user_middlename, user_email, male, date_of_birth, passport_data FROM lk WHERE user_email=$1", email).Scan(&userName, &userSurname, &userMiddlename, &userEmail, &male, &dateOfBirth, &passportData)
		if err != nil {
			http.Error(w, "Ошибка получения данных пользователя", http.StatusInternalServerError)
			log.Printf("Ошибка получения данных пользователя: %v", err)
			return
		}

		// Форматирование даты рождения в строку "YYYY-MM-DD"
		formattedDateOfBirth := dateOfBirth.Format("2006-01-02")

		// Сохранение данных в сессию
		session, _ := store.Get(r, "session")
		session.Values["authenticated"] = true
		session.Values["userName"] = userName
		session.Values["userSurname"] = userSurname
		session.Values["userMiddlename"] = userMiddlename
		session.Values["userEmail"] = userEmail
		session.Values["male"] = male
		session.Values["dateOfBirth"] = formattedDateOfBirth
		session.Values["passportData"] = passportData
		err = session.Save(r, w)
		if err != nil {
			http.Error(w, "Ошибка сохранения сессии", http.StatusInternalServerError)
			log.Printf("Ошибка сохранения сессии: %v", err)
			return
		}

		// Перенаправление в кабинет
		http.Redirect(w, r, "/cabinet", http.StatusFound)
		log.Println("Аутентификация успешна, перенаправление в кабинет.")
		return
	}

	// Отображение страницы логина
	t, err := template.ParseFiles("templates/login.html", "templates/header.html", "templates/footer.html")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	err = t.ExecuteTemplate(w, "login", nil)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func generatePDF(w http.ResponseWriter, id int, convTime time.Time, amountIn, amountOut float64, currencyIn, currencyOut, userEmail string) {
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
	pdf.Ln(10)
	pdf.Cell(40, 10, fmt.Sprintf("User Email: %s", userEmail))

	err := pdf.Output(w)
	if err != nil {
		http.Error(w, fmt.Sprintf("Ошибка генерации PDF: %v", err), http.StatusInternalServerError)
	}
}

func save(w http.ResponseWriter, r *http.Request) {
	// Проверка аутентификации
	session, err := store.Get(r, "session")
	if err != nil {
		http.Error(w, "Ошибка получения сессии", http.StatusInternalServerError)
		return
	}

	auth, ok := session.Values["authenticated"].(bool)
	if !ok || !auth {
		http.Error(w, "Сначала выполните вход", http.StatusUnauthorized)
		log.Println("Попытка выполнения операции без аутентификации.")
		return
	}

	userEmail, _ := session.Values["userEmail"].(string)
	if r.Method != http.MethodPost {
		http.Error(w, "Метод должен быть POST", http.StatusMethodNotAllowed)
		return
	}

	inputCourseStr := r.FormValue("inputCourse")
	outputCourseStr := r.FormValue("outputCourse")
	take := r.FormValue("take")
	give := r.FormValue("give")

	inputCourse, err := strconv.ParseFloat(inputCourseStr, 64)
	if err != nil || inputCourse < 0 {
		http.Error(w, "Некорректное значение inputCourse: не может быть отрицательным", http.StatusBadRequest)
		return
	}
	if inputCourse == 0 {
		http.Error(w, "inputCourse не может быть нулем", http.StatusBadRequest)
		return
	}

	outputCourse, err := strconv.ParseFloat(outputCourseStr, 64)
	if err != nil || outputCourse < 0 {
		http.Error(w, "Некорректное значение outputCourse: не может быть отрицательным", http.StatusBadRequest)
		return
	}

	connStr := "postgres://postgres:Googleapple123@localhost:5432/course"
	conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		http.Error(w, fmt.Sprintf("Ошибка подключения к БД: %v", err), http.StatusInternalServerError)
		return
	}
	defer conn.Close(context.Background())

	// Получение user_id из таблицы lk на основе email пользователя
	var userID int
	err = conn.QueryRow(
		context.Background(),
		"SELECT id FROM lk WHERE user_email = $1",
		userEmail,
	).Scan(&userID)
	if err != nil {
		http.Error(w, fmt.Sprintf("Ошибка получения userID: %v", err), http.StatusInternalServerError)
		return
	}

	currentTime := time.Now()
	startOfDay := currentTime.Truncate(24 * time.Hour)
	endOfDay := startOfDay.Add(24*time.Hour - 1)

	// Проверка суммарной дневной конвертации
	var totalConvertedToday float64
	err = conn.QueryRow(
		context.Background(),
		"SELECT COALESCE(SUM(amount_in), 0) FROM Convert WHERE lk_id = $1 AND currency_in = $2 AND conv_time BETWEEN $3 AND $4",
		userID, take, startOfDay, endOfDay,
	).Scan(&totalConvertedToday)
	if err != nil {
		http.Error(w, fmt.Sprintf("Ошибка проверки дневной лимит конвертации: %v", err), http.StatusInternalServerError)
		return
	}

	if totalConvertedToday+inputCourse > 1000 {
		http.Error(w, "Дневной лимит конвертации для одной валюты превышен (максимум 1000 единиц)", http.StatusForbidden)
		return
	}

	var id int
	err = conn.QueryRow(
		context.Background(),
		"INSERT INTO Convert (amount_in, amount_out, conv_time, currency_in, currency_out, lk_id, user_email) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id",
		inputCourse,
		outputCourse,
		currentTime,
		take,
		give,
		userID,
		userEmail,
	).Scan(&id)
	if err != nil {
		http.Error(w, fmt.Sprintf("Ошибка выполнения запроса: %v", err), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/pdf")
	w.Header().Set("Content-Disposition", "inline; filename=\"receipt.pdf\"")

	generatePDF(w, id, currentTime, inputCourse, outputCourse, take, give, userEmail)
}

func cabinet(w http.ResponseWriter, r *http.Request) {
	// Получение сессии
	session, err := store.Get(r, "session")
	if err != nil {
		http.Error(w, "Ошибка получения сессии", http.StatusInternalServerError)
		return
	}

	// Проверка аутентификации
	auth, ok := session.Values["authenticated"].(bool)
	if !ok || !auth {
		http.Error(w, "Сначала выполните вход", http.StatusUnauthorized)
		log.Println("Попытка доступа к кабинету без аутентификации.")
		return
	}

	// Подготовка данных для шаблона
	data := map[string]interface{}{
		"UserName":       session.Values["userName"],
		"UserSurname":    session.Values["userSurname"],
		"UserMiddlename": session.Values["userMiddlename"],
		"UserEmail":      session.Values["userEmail"],
		"Male":           session.Values["male"],
		"DateOfBirth":    session.Values["dateOfBirth"],
		"PassportData":   session.Values["passportData"],
	}

	// Отображение страницы кабинета
	t, err := template.ParseFiles("templates/cabinet.html", "templates/header.html", "templates/footer.html")
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	err = t.ExecuteTemplate(w, "cabinet", data)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func logout(w http.ResponseWriter, r *http.Request) {
	session, _ := store.Get(r, "session")

	session.Values["authenticated"] = false
	session.Save(r, w)
	http.Redirect(w, r, "/login", http.StatusFound)
}

func getReportPeriodDates(period string) (time.Time, time.Time) {
	now := time.Now()
	var startDate time.Time

	switch period {
	case "day":
		startDate = now.AddDate(0, 0, -1)
	case "week":
		startDate = now.AddDate(0, 0, -7)
	case "month":
		startDate = now.AddDate(0, -1, 0)
	case "year":
		startDate = now.AddDate(-1, 0, 0)
	default:
		startDate = now.AddDate(0, 0, -1)
	}

	return startDate, now
}

func generateReport(w http.ResponseWriter, r *http.Request) {
	// Проверка аутентификации
	session, err := store.Get(r, "session")
	if err != nil {
		http.Error(w, "Ошибка получения сессии", http.StatusInternalServerError)
		return
	}

	auth, ok := session.Values["authenticated"].(bool)
	if !ok || !auth {
		http.Error(w, "Сначала выполните вход", http.StatusUnauthorized)
		log.Println("Попытка выполнения операции без аутентификации.")
		return
	}

	userEmail, _ := session.Values["userEmail"].(string)
	period := r.URL.Query().Get("period")

	startDate, endDate := getReportPeriodDates(period)

	connStr := "postgres://postgres:Googleapple123@localhost:5432/course"
	conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		http.Error(w, fmt.Sprintf("Ошибка подключения к БД: %v", err), http.StatusInternalServerError)
		return
	}
	defer conn.Close(context.Background())

	rows, err := conn.Query(
		context.Background(),
		"SELECT id, conv_time, amount_in, amount_out, currency_in, currency_out, user_email FROM Convert WHERE user_email = $1 AND conv_time BETWEEN $2 AND $3",
		userEmail,
		startDate,
		endDate,
	)
	if err != nil {
		http.Error(w, fmt.Sprintf("Ошибка выполнения запроса: %v", err), http.StatusInternalServerError)
		return
	}
	defer rows.Close()

	pdf := gofpdf.New("P", "mm", "A4", "")
	pdf.AddPage()
	pdf.SetFont("Arial", "B", 16)
	pdf.Cell(40, 10, "Report")
	pdf.Ln(20)

	pdf.SetFont("Arial", "", 12)
	for rows.Next() {
		var id int
		var convTime time.Time
		var amountIn, amountOut float64
		var currencyIn, currencyOut, userEmail string

		err := rows.Scan(&id, &convTime, &amountIn, &amountOut, &currencyIn, &currencyOut, &userEmail)
		if err != nil {
			http.Error(w, fmt.Sprintf("Ошибка сканирования строки: %v", err), http.StatusInternalServerError)
			continue
		}

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
		pdf.Ln(20)
	}

	err = rows.Err()
	if err != nil {
		http.Error(w, fmt.Sprintf("Ошибка при обработке результата запроса: %v", err), http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/pdf")
	w.Header().Set("Content-Disposition", "inline; filename=\"report.pdf\"")

	err = pdf.Output(w)
	if err != nil {
		http.Error(w, fmt.Sprintf("Ошибка генерации PDF: %v", err), http.StatusInternalServerError)
	}
}

func handleFunc() {
	http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("./static/"))))
	http.HandleFunc("/", index)
	http.HandleFunc("/save", save)
	http.HandleFunc("/reg", reg)
	http.HandleFunc("/login", login)
	http.HandleFunc("/cabinet", cabinet)
	http.HandleFunc("/logout", logout)
	http.HandleFunc("/report", generateReport)
	fmt.Println("Server is listening: http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func main() {
	handleFunc()
}
