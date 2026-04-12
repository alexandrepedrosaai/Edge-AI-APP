#include <iostream>

// Declaração da função Assembly
extern "C" void pipeline();

int main() {
    // Executa a rotina em Assembly
    pipeline();

    // Feedback para o usuário
    std::cout << "Pipeline executado com sucesso!" << std::endl;
    return 0;
}
