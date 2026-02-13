FROM ubuntu:22.04

RUN apt-get update && apt-get install -y g++ cmake

WORKDIR /app
COPY . .

RUN mkdir build && cd build && cmake .. && make

CMD ["./build/EdgeAIApp"]
