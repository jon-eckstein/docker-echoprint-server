A Dockerfile for echoprint-server.

To build: docker build -t "echoprint-server" .

To run: sudo docker run -d -i -t -p 8555:8555 -p 8502:8502 echoprint-server:latest 