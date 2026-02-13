`cpp

include <iostream>

include "server.h"

int main() {
    Server app(8080);
    app.start();
    return 0;
}
`
