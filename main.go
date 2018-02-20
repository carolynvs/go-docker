package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"

	"github.com/gorilla/mux"
)

var msg = "I love Go!"

func init() {
	customMessage, ok := os.LookupEnv("MESSAGE")
	if ok {
		msg = customMessage
	}
}

func main() {
	//http.Handle("/static/", http.StripPrefix("/static/", http.FileServer(http.Dir("static/"))))
	//http.HandleFunc("/", printMessage)
	//http.ListenAndServe(":80", nil)

	r := mux.NewRouter()

	// This will serve files under http://localhost:8000/static/<filename>
	r.PathPrefix("/static/").Handler(http.StripPrefix("/static/", http.FileServer(http.Dir("static/"))))

	r.HandleFunc("/", homeHandler)

	http.ListenAndServe(":80", r)
}

func homeHandler(w http.ResponseWriter, r *http.Request) {
	page := `
<html>
	<head>
		<link rel="stylesheet" href="/static/css/site.css"/>
	</head>
	<body>
		<p>MESSAGE</p>
	</body>
</html>
`
	fmt.Println(msg)
	io.WriteString(w, strings.Replace(page, "MESSAGE", msg, 1))
}
