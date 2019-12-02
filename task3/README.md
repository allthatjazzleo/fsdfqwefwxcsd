# URL_SHORTENER

> URL Shortener API Service for Kubernetes

---
## Design

- API is programmed with __*Golang*__ to provide high performance
- Redis HA with AWS ElastiCache as Redis storage service that provides failover and sharding feature
- URL Shortener API is hosted in AWS Fargate as docker solution
- URL Shortener API can scale in/out with load by __*autoscaling group*__. It can scale out when cpu reach 85%. See more in `auto_scaling.tf`
- Traffics can be directed to API service container from AWS ALB (certifcate can be added for ssl termination)
---
## Prerequisite To Deploy
- User has AWS account
- User has enough permission to execute terraform script
- User has installed terraform cli

## Deploy

Before running `terraform plan` and `terraform apply` in `./deploy.sh`, set a few environment variables with your AWS account details, for more information on using Terraform with AWS please take a look at this post  [Terraform: Beyond the Basics with AWS | AWS Partner Network (APN) Blog](https://aws.amazon.com/blogs/apn/terraform-beyond-the-basics-with-aws/)
 
```bash
export AWS_ACCESS_KEY_ID=[AWS ACCESS KEY ID]
export AWS_SECRET_ACCESS_KEY=[AWS SECRET ACCESS KEY]
export AWS_REGION=[AWS REGION, e.g. eu-west-1]
```
Run deploy script
(it takes few minutes to complete)
```
$ ./deploy.sh
```
Output:
```
Outputs:

alb_endpoint_address = xxxxxxxxxxx.ap-southeast-1.elb.amazonaws.com
configuration_endpoint_address = xxxxxxxx.judoe0.clustercfg.apse1.cache.amazonaws.com
```
## Caveat

From my experience, after ecs faraget is deployed, it may take 10-15 minutes to fully work when accessing to AWS ElastiCache due to `awsvpc network mode` in VPC.
When you encounter **502 bad gateway**, please be patient! 
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