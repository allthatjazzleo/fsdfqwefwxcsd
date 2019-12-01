package redis

import (
	"os"

	"github.com/go-redis/redis"
)

// RedisEndpoint is Redis endpoint
var RedisEndpoint = redisEndpoint()

// RedisPassword is Redis password
var RedisPassword = redisPassword()

// RedisPort is Redis port
var RedisPort = redisPort()

// Client is redis client
var Client = redis.NewClient(&redis.Options{
	Addr:     RedisEndpoint + ":" + RedisPort,
	Password: RedisPassword, // no password set
	DB:       0,             // use default DB
})

// Nil export redis.nil
var Nil = redis.Nil

// get redis endpoint, password, port from env
func redisEndpoint() (r string) {
	if r = os.Getenv("REDIS_ENDPOINT"); r == "" {
		return "localhost"
	}
	return
}

func redisPassword() (r string) {
	if r = os.Getenv("REDIS_PASSWORD"); r == "" {
		return ""
	}
	return
}

func redisPort() (r string) {
	if r = os.Getenv("REDIS_PORT"); r == "" {
		return "6379"
	}
	return
}
