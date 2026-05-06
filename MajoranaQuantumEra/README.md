# 🚀 Majorana Quantum Era Simulator

**Simulador completo de Majorana Zero Modes, Braiding Não-Abeliano em 2D, aplicações em IA e Criptografia.**

Última atualização: 2026

![Majorana 2D Spectrum](majorana_2d_spectrum.png)

## 1. Majorana Zero Modes (MZMs)
- Partículas = antipartículas (γ = γ†)
- Energia exatamente zero nas bordas/vórtices
- Proteção topológica não-local

## 2. Kitaev Chain 1D + Rede 2D
- Transição de fase visualizada
- Espectro com Zero Modes em |μ| < 2t

![Espectro 2D](majorana_2d_spectrum.png)

## 3. Braiding Não-Abeliano
- Em hardware: **Microsoft Majorana 1** (tetron architecture, 2025)
- Measurement-based braiding (X/Z loop measurements)
- Operações não-comutativas → gates lógicos protegidos

## 4. Aplicações
- **Criptografia**: QKD topológica + detecção automática de ataques
- **IA Quântica**: VQA estável, Quantum Clustering, Kernel Methods
- **Computação Topológica**: Base para fault-tolerant quantum computing

## 5. Como Rodar
```bash
pip install -r requirements.txt
python kitaev_2d_sim.py
docker run ghcr.io/alexandrepedrosaai/majorana-quantum-era
