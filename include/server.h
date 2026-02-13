`cpp

ifndef SERVER_H

define SERVER_H

class Server {
public:
    explicit Server(int port);
    void start();
private:
    int port_;
};
