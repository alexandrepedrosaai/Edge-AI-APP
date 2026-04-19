#include "Vtop_entity.h"
#include "verilated.h"
#include <iostream>
#include <memory>

// Função para simular o passar do tempo (toggle do clock)
void tick(int &main_time, std::unique_ptr<Vtop_entity> &top) {
    top->clk = !top->clk;
    top->eval();
    main_time++;
}

int main(int argc, char** argv) {
    // Inicializa argumentos do Verilator
    Verilated::commandArgs(argc, argv);

    // Instancia o módulo top_entity
    auto top = std::make_unique<Vtop_entity>();

    int main_time = 0;
    
    // Inicialização de sinais
    top->clk = 0;
    top->reset_n = 0; // Ativa reset (negativo)
    top->button = 0;

    std::cout << "Iniciando simulação Verilator para top_entity..." << std::endl;

    // 1. Ciclo de Reset
    for (int i = 0; i < 10; i++) {
        tick(main_time, top);
    }
    top->reset_n = 1; // Desativa reset
    std::cout << "Reset liberado em t=" << main_time << std::endl;

    // 2. Teste de Estímulos (Simulando pressionamento de botões)
    // Botão 1
    top->button = 0b01;
    for (int i = 0; i < 20; i++) tick(main_time, top);
    std::cout << "Botão 01 pressionado. LED: " << (int)top->led << std::endl;

    // Botão 2
    top->button = 0b10;
    for (int i = 0; i < 20; i++) tick(main_time, top);
    std::cout << "Botão 10 pressionado. LED: " << (int)top->led << std::endl;

    // Botão 3
    top->button = 0b11;
    for (int i = 0; i < 20; i++) tick(main_time, top);
    std::cout << "Botão 11 pressionado. LED: " << (int)top->led << std::endl;

    // Finalização
    top->final();
    std::cout << "Simulação finalizada com sucesso em t=" << main_time << std::endl;

    return 0;
}
