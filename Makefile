VERSION=0.0.1

IMAGE ?= m2web

build:
	git clone https://github.com/pzinn/Macaulay2Web.git
	ssh-keygen -b 1024 -f id_rsa -P ''
	mv id_rsa ./server/
	cp id_rsa.pub ./server/
	cp id_rsa.pub ./Macaulay2Web/
	cd Macaulay2Web && docker buildx build --load -t m2web:latest -f Dockerfile .
	mkdir -p ./Macaulay2Web
	cd ./Macaulay2Web && docker pull pzinn/m2container && docker build -t m2container .
	rm ./server/id_rsa ./server/id_rsa.pub
	rm -rf ./Macaulay2Web

run:
	docker compose up

clean:
	docker compose down
	@docker ps -aq | xargs -r docker stop
	-docker buildx prune -af
	docker system prune -af