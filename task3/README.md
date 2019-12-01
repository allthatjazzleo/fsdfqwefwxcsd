# URL_SHORTENER

> URL Shortener API Service for Kubernetes

---
## Design

- API is programmed with __*Golang*__ to provide high performance
- Redis HA with AWS ElastiCache as Redis storage service that provides failover and sharding feature
- URL Shortener API can scale in/out with load by __*K8S Horizontal Pod Autoscaler*__. It can scale out when cpu reach 80%. See more in `deploy.sh`
- Traffics can be directed to API service pods by using __*Ingress controller*__
---
## Prerequisite To Deploy
- User has already provisioned k8s environment
- User has already apply ingress controller to k8s to direct external traffic to __*service*__ with ingress rule
- User has already provisioned ElastiCashe Redis to the VPC (the same VPC with k8s cluster)
- kubectl cli and docker cli are installed

##### Provide Environment Variables in `kubernetes-manifests/url-shortener-deployment.yaml`
| Name          | Required | Default Value           | Description                                                     |
|---------------|----------|-------------------------|-----------------------------------------------------------------|
| REDIS_ENDPOINT  | No       | localhost                    | The redis endpoint to connect AWS ElastiCache           |
| REDIS_PASSWORD        | No       | none | The redis password to connect AWS ElastiCache by token                                               |
| REDIS_PORT | No       | 6379                 | The redis port to connect |
| DOMAIN | No       | localhost                  | The domain for returned shorten url eg. bitly.com |

## Deploy

```
$ ./deploy.sh
```

## Local Development and Testing

>Start local redis server
```
$ redis-server 
```
>Start API server (assume you installed go)
```
$ cd ./cmd/app
$ go build 
$ ./app
```
>Test API by POSTMAN
```
POST /newurl
- Request: { "url": "​https://www.google.com​" }
GET​ /[a-zA-Z0-9]{9}​ (regex,​ eg.​ g20hi33k9)
```