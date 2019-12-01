package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/allthatjazzleo/fsdfqwefwxcsd/task3/pkg/random"
	"github.com/allthatjazzleo/fsdfqwefwxcsd/task3/pkg/redis"

	"github.com/gorilla/mux"
)

type url struct {
	URL        string `json:"url"`
	SHORTENURI string `json:"shortenUri"`
}

// Domain is shorturl domain eg. bitly.com
var Domain = domain()

func main() {
	r := mux.NewRouter()
	// /submit url to be short by check body
	r.HandleFunc("/newurl", submitHandler).Methods("POST")
	r.HandleFunc("/{url:[0-9a-zA-Z]{9}}", getHandler).Methods("GET")
	r.HandleFunc("/ping", healthCheckHandler).Methods("GET")
	fmt.Println("server running on 3000 ")
	log.Fatal(http.ListenAndServe(":3000", r))
}

// return shorten url
func submitHandler(w http.ResponseWriter, r *http.Request) {
	defer r.Body.Close()

	var v url
	if err := json.NewDecoder(r.Body).Decode(&v); err != nil {
		http.Error(w, fmt.Sprintf("failed to decode request body into json: %+v", err), http.StatusBadRequest)
		return
	}
	if v.URL == "" {
		http.Error(w, "empty 'url' value", http.StatusBadRequest)
		return
	}
	client := redis.Client
	setDone := false
	for !setDone {
		genKey := random.GenerateRandom(9)
		set, err := client.SetNX(genKey, v.URL, 168*time.Hour).Result()
		if err != nil {
			panic(err)
		} else if set {
			fmt.Println("generated", genKey, v.URL)
			v.SHORTENURI = "https://" + Domain + "/" + genKey
			js, err := json.Marshal(v)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			w.Header().Set("Content-Type", "application/json")
			w.Write(js)
			setDone = true
		} else {
			fmt.Println("generated url already exist! And need to generate new one")
			setDone = false
		}
	}

}

// redirect original url
func getHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	randomVar := vars["url"]
	fmt.Println("get ", randomVar)
	client := redis.Client
	url, err := client.Get(randomVar).Result()
	if err == redis.Nil {
		fmt.Println("key does not exist")
	} else if err != nil {
		panic(err)
	} else {
		fmt.Println("key", url)
		http.Redirect(w, r, url, 302)
	}
}

// healthCheckHandler is a liveness probe.
func healthCheckHandler(w http.ResponseWriter, _ *http.Request) {
	w.WriteHeader(http.StatusOK)
}

// Get domain from env
func domain() (d string) {
	if d = os.Getenv("DOMAIN"); d == "" {
		return "localhost:3000"
	}
	return
}
