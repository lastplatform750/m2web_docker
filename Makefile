VERSION=0.0.1

IMAGE ?= m2web

build:
	docker build -t m2web:latest -f Dockerfile .

run:
	docker run -p 8002:8002 m2web

clean:
	@docker ps -aq --filter "ancestor=$(IMAGE)" | xargs -r docker stop
	@docker ps -aq --filter "ancestor=$(IMAGE)" | xargs -r docker rm
	docker container prune -f
	docker image prune -f