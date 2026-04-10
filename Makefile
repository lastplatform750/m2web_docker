VERSION=0.0.1

build:
	docker build -t m2web:latest -f Dockerfile .

run:
	docker run -p 8002:8002 m2web