VERSION=0.0.1

IMAGE ?= m2web

build:
	cd server && docker buildx build --load -t m2web:latest -f Dockerfile .
	mkdir -p ./m2
	cd ./m2 && docker pull pzinn/m2container && docker build -t m2container .

run:
	docker compose up

clean:
	docker compose down
	@docker ps -aq | xargs -r docker stop
	-docker buildx prune -af
	docker system prune -af