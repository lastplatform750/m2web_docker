**m2web docker**

A docker image that puts all of https://github.com/pzinn/Macaulay2Web in one big docker. The guest runs everything as root and it probably isn't secure at all.

Build command (in directory):
`docker build -t m2web:latest .`

Run command:
`docker run -p 8002:8002 m2web`