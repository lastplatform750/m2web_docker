VERSION=0.0.1

build:
	docker build -t m2web:latest -f Dockerfile .

run:
	docker run -p 8002:8002 m2web

clean:
	docker container stop $(shell docker container ls -aq)
	docker container prune -f
	docker image prune -f