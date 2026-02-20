import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { CheckCircle2, Cloud, Code2, Download, GitBranch, Zap, ArrowRight, ExternalLink } from "lucide-react";
import { useState } from "react";

export default function Home() {
  const [activeTab, setActiveTab] = useState("overview");

  const heroImageUrl = "https://private-us-east-1.manuscdn.com/sessionFile/ZWCSxvKZUf8Fcq2NgwRWyF/sandbox/bQ7ZwmgPm2I6AG5AvAwimc-img-1_1771311638000_na1fn_aGVyby1henVyZS1mdW5jdGlvbnM.png?x-oss-process=image/resize,w_1920,h_1920/format,webp/quality,q_80&Expires=1798761600&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9wcml2YXRlLXVzLWVhc3QtMS5tYW51c2Nkbi5jb20vc2Vzc2lvbkZpbGUvWldDU3h2S1pVZjhGY3EyTmd3Uld5Ri9zYW5kYm94L2JRN1p3bWdQbTJJNkFHNUF2QXdpbWMtaW1nLTFfMTc3MTMxMTYzODAwMF9uYTFmbl9hR1Z5YnkxaGVuVnlaUzFtZFc1amRHbHZibk0ucG5nP3gtb3NzLXByb2Nlc3M9aW1hZ2UvcmVzaXplLHdfMTkyMCxoXzE5MjAvZm9ybWF0LHdlYnAvcXVhbGl0eSxxXzgwIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNzk4NzYxNjAwfX19XX0_&Key-Pair-Id=K2HSFNDJXOU9YS&Signature=NGljWU9WzpDYiezLNagB20en6c5B6aaUQbkxXzVqF-lktNzHgo5e4wqMzcg3r815EOXr~g3CTxkaF0tES5nYYd6TgWAqxZmI9rRIMITUDtEMCxVo8MsEH9NqTjsIdKia7eQfoq6Xh5qfrWlE2cL50bWNK0lZ4LKNZk2i3sc9hd~MJoNm8y~toEfvPOGycKlKT3yLMt3qdX2dHzcNnoPMWw-DchhPTM2M8gtNjO0qatP9rTWq1CL-SFetZsElO09VBIlHhklFtBIKqR2Vu0JaX3~XzaBFDf0oyP9s6L90LM~vCpq9vEuwH8j520Pu1teywIqsvdCSQ2Nxcpjv1803zw__";
  const deploymentFlowUrl = "https://private-us-east-1.manuscdn.com/sessionFile/ZWCSxvKZUf8Fcq2NgwRWyF/sandbox/bQ7ZwmgPm2I6AG5AvAwimc-img-2_1771311630000_na1fn_ZGVwbG95bWVudC1mbG93.png?x-oss-process=image/resize,w_1920,h_1920/format,webp/quality,q_80&Expires=1798761600&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9wcml2YXRlLXVzLWVhc3QtMS5tYW51c2Nkbi5jb20vc2Vzc2lvbkZpbGUvWldDU3h2S1pVZjhGY3EyTmd3Uld5Ri9zYW5kYm94L2JRN1p3bWdQbTJJNkFHNUF2QXdpbWMtaW1nLTJfMTc3MTMxMTYzMDAwMF9uYTFmbl9aR1Z3Ykc5NWJXVnVkQzFtYkc5My5wbmc~eC1vc3MtcHJvY2Vzcz1pbWFnZS9yZXNpemUsd18xOTIwLGhfMTkyMC9mb3JtYXQsd2VicC9xdWFsaXR5LHFfODAiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3OTg3NjE2MDB9fX1dfQ__&Key-Pair-Id=K2HSFNDJXOU9YS&Signature=tA4oU1v3clSRl90Amr2wvj92qhmhdkYLYyVR2ZSda6qlW~mV17tEkN4aP2O7a9W25HTg56kB9ICe1sqh5buBTxeOCNZ5UVr2xJ4dABJyg6k9F7gZHgJodYpcY5Kf-KEUTTzlb5spTh8T6WRsxZ-Mo546jre0hvK4nHwFCS7ZcPcsHSbkI8vcx9IAj2GI0RWvaz0ZZomuiGofDfsW8mL5w7c634hxRk0-17OKuPaglI21D-TYD4ImuA~tU0ROomkOoAMp1paNXmzF9eNsZ8uRibvOTtq~jtmZjo4IISolFtKtAnG-3-zfLBmdOL3rTIZKXM6qkhLb8veks81yZe1Ikg__";
  const scriptsAutomationUrl = "https://private-us-east-1.manuscdn.com/sessionFile/ZWCSxvKZUf8Fcq2NgwRWyF/sandbox/bQ7ZwmgPm2I6AG5AvAwimc-img-3_1771311644000_na1fn_c2NyaXB0cy1hdXRvbWF0aW9u.png?x-oss-process=image/resize,w_1920,h_1920/format,webp/quality,q_80&Expires=1798761600&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9wcml2YXRlLXVzLWVhc3QtMS5tYW51c2Nkbi5jb20vc2Vzc2lvbkZpbGUvWldDU3h2S1pVZjhGY3EyTmd3Uld5Ri9zYW5kYm94L2JRN1p3bWdQbTJJNkFHNUF2QXdpbWMtaW1nLTNfMTc3MTMxMTY0NDAwMF9uYTFmbl9jMk55YVhCMGN5MWhkWFJ2YldGMGFXOXUucG5nP3gtb3NzLXByb2Nlc3M9aW1hZ2UvcmVzaXplLHdfMTkyMCxoXzE5MjAvZm9ybWF0LHdlYnAvcXVhbGl0eSxxXzgwIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNzk4NzYxNjAwfX19XX0_&Key-Pair-Id=K2HSFNDJXOU9YS&Signature=BTBw2F~~1Z~HTqurL0u3m3OI5rYrXcvEZFZWfi05GKx0LwDWBKhF9Mr3tw8jRn7VefOKZP5fXfzzAdJz~UzTUjR32NLFhoUsNg1HTPFS1ubr6o~RW5QkgcrpjOvjdrakPUxrOjyMJAwujNu-i51ZnCG4u~uA211Af2NmSbnHUGxIOFFkXOMhdz7OngiWueg3gFVc5SafoeO~zXUBFqc~4REnYrdrH9ztj2m0NJhhDcs~b23VvnisiO-1qr2AYXJCdZjpyekMf3PZTWKBQlDCHdmZcdtN3PO4xgKf~vPI9JKuUdMkdrOh7eJHaFRcugI1-iwHWHapouKfea-I1HfCmA__";
  const successDeploymentUrl = "https://private-us-east-1.manuscdn.com/sessionFile/ZWCSxvKZUf8Fcq2NgwRWyF/sandbox/bQ7ZwmgPm2I6AG5AvAwimc-img-4_1771311648000_na1fn_c3VjY2Vzcy1kZXBsb3ltZW50.png?x-oss-process=image/resize,w_1920,h_1920/format,webp/quality,q_80&Expires=1798761600&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9wcml2YXRlLXVzLWVhc3QtMS5tYW51c2Nkbi5jb20vc2Vzc2lvbkZpbGUvWldDU3h2S1pVZjhGY3EyTmd3Uld5Ri9zYW5kYm94L2JRN1p3bWdQbTJJNkFHNUF2QXdpbWMtaW1nLTRfMTc3MTMxMTY0ODAwMF9uYTFmbl9jM1ZqWTJWemN5MWtaWEJzYjNsdFpXNTAucG5nP3gtb3NzLXByb2Nlc3M9aW1hZ2UvcmVzaXplLHdfMTkyMCxoXzE5MjAvZm9ybWF0LHdlYnAvcXVhbGl0eSxxXzgwIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNzk4NzYxNjAwfX19XX0_&Key-Pair-Id=K2HSFNDJXOU9YS&Signature=BQXd4rYsoAwXfNc6n8ERnvQFK3qehYE6nYnLGOKthHcJX5rsVBakFqU5ENZa-UY4qxvznDIcONUJ3yKW-TIIO~GVwRGS1IOck-ASYRfQssDHvvMAaTJXS1AD8H893RiYMB~9tGb6iOXxrLFq1trtYRaEuR5s1wl5A0Cbvzg2o8dTRvtv4BtTi2Qh-p0iMmJM~zaCU12oXWUQdL2-Hj136ourPN7QlPgjTW~dBcRtyP-jFolzc0BgdO9kxz5d28wycsG~9VLmUWN9Qn6kJRU~I8Z0KpIL67klt1eBiGehOOjA2CPH4JGJl03b1ElUley4brus362w2AhFtaXZvyOSPw__";

  return (
    <div className="min-h-screen bg-white">
      {/* Navigation */}
      <nav className="sticky top-0 z-50 border-b border-gray-200 bg-white/80 backdrop-blur-md">
        <div className="container flex items-center justify-between py-4">
          <div className="flex items-center gap-2">
            <Cloud className="h-8 w-8 text-primary" />
            <span className="text-xl font-bold text-foreground">Edge AI Deploy</span>
          </div>
          <div className="flex items-center gap-4">
            <a href="#guides" className="text-sm font-medium text-foreground hover:text-primary transition">Guias</a>
            <a href="#scripts" className="text-sm font-medium text-foreground hover:text-primary transition">Scripts</a>
            <a href="#faq" className="text-sm font-medium text-foreground hover:text-primary transition">FAQ</a>
            <Button className="bg-primary hover:bg-primary/90">
              <Download className="mr-2 h-4 w-4" />
              Download
            </Button>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="relative overflow-hidden bg-gradient-to-b from-blue-50 to-white py-20">
        <div className="container grid grid-cols-2 gap-12 items-center">
          <div>
            <h1 className="text-5xl font-bold text-foreground mb-6 leading-tight">
              Deploy Azure Functions<br />
              <span className="text-primary">Simples e Automatizado</span>
            </h1>
            <p className="text-xl text-gray-600 mb-8">
              Transforme seu Edge AI App em produção com 3 comandos. Tudo automatizado, documentado e pronto para escalar.
            </p>
            <div className="flex gap-4">
              <Button size="lg" className="bg-primary hover:bg-primary/90">
                <Zap className="mr-2 h-5 w-5" />
                Começar Agora
              </Button>
              <Button size="lg" variant="outline">
                <ExternalLink className="mr-2 h-5 w-5" />
                Ver no GitHub
              </Button>
            </div>
          </div>
          <div className="relative">
            <img 
              src={heroImageUrl}
              alt="Azure Functions Deployment"
              className="w-full rounded-2xl shadow-2xl"
            />
          </div>
        </div>
      </section>

      {/* Features */}
      <section className="py-20 bg-white">
        <div className="container">
          <h2 className="text-4xl font-bold text-center mb-16">Por que escolher este deploy?</h2>
          <div className="grid grid-cols-3 gap-8">
            {[
              {
                icon: <Zap className="h-8 w-8" />,
                title: "100% Automatizado",
                description: "4 scripts que fazem todo o trabalho. Sem configuração manual complexa."
              },
              {
                icon: <Code2 className="h-8 w-8" />,
                title: "Código Pronto",
                description: "Azure Functions, Docker, GitHub Actions - tudo configurado e testado."
              },
              {
                icon: <Cloud className="h-8 w-8" />,
                title: "Produção Ready",
                description: "Monitoramento, logs, CI/CD automático. Pronto para escalar."
              }
            ].map((feature, i) => (
              <Card key={i} className="border-gray-200 hover:border-primary transition">
                <CardHeader>
                  <div className="text-primary mb-4">{feature.icon}</div>
                  <CardTitle>{feature.title}</CardTitle>
                </CardHeader>
                <CardContent>
                  <p className="text-gray-600">{feature.description}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Deployment Flow */}
      <section className="py-20 bg-gray-50">
        <div className="container">
          <h2 className="text-4xl font-bold text-center mb-12">Como funciona</h2>
          <img 
            src={deploymentFlowUrl}
            alt="Deployment Flow"
            className="w-full rounded-2xl shadow-lg mb-12"
          />
          <div className="grid grid-cols-5 gap-4">
            {[
              { step: "1", title: "GitHub", desc: "Push código" },
              { step: "2", title: "Actions", desc: "Build automático" },
              { step: "3", title: "ACR", desc: "Push imagem" },
              { step: "4", title: "Functions", desc: "Deploy container" },
              { step: "5", title: "Live", desc: "Produção" }
            ].map((item, i) => (
              <div key={i} className="text-center">
                <div className="bg-primary text-white rounded-full w-12 h-12 flex items-center justify-center mx-auto mb-4 font-bold">
                  {item.step}
                </div>
                <h3 className="font-semibold text-foreground">{item.title}</h3>
                <p className="text-sm text-gray-600">{item.desc}</p>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Quick Start */}
      <section className="py-20 bg-white" id="guides">
        <div className="container">
          <h2 className="text-4xl font-bold mb-12">Começar em 3 Passos</h2>
          <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
            <TabsList className="grid w-full grid-cols-3 mb-8">
              <TabsTrigger value="step1">Passo 1: Setup Azure</TabsTrigger>
              <TabsTrigger value="step2">Passo 2: GitHub Secrets</TabsTrigger>
              <TabsTrigger value="step3">Passo 3: Deploy</TabsTrigger>
            </TabsList>

            <TabsContent value="step1" className="space-y-4">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <CheckCircle2 className="h-5 w-5 text-green-600" />
                    Setup Azure Resources
                  </CardTitle>
                  <CardDescription>Cria todos os recursos necessários no Azure</CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="bg-gray-900 text-green-400 p-4 rounded-lg font-mono text-sm overflow-x-auto">
                    <div>$ ./1-setup-azure-resources.sh</div>
                  </div>
                  <div className="space-y-2">
                    <p className="font-semibold text-foreground">O que acontece:</p>
                    <ul className="space-y-2">
                      {[
                        "✅ Cria Resource Group",
                        "✅ Cria Azure Container Registry",
                        "✅ Cria Storage Account",
                        "✅ Cria Function App",
                        "✅ Configura Application Insights"
                      ].map((item, i) => (
                        <li key={i} className="text-gray-700">{item}</li>
                      ))}
                    </ul>
                  </div>
                  <p className="text-sm text-gray-600">⏱️ Tempo: 5-10 minutos</p>
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="step2" className="space-y-4">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <CheckCircle2 className="h-5 w-5 text-green-600" />
                    Configurar GitHub Secrets
                  </CardTitle>
                  <CardDescription>Configura secrets para CI/CD automático</CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="bg-gray-900 text-green-400 p-4 rounded-lg font-mono text-sm overflow-x-auto">
                    <div>$ ./2-configure-github-secrets.sh</div>
                  </div>
                  <div className="space-y-2">
                    <p className="font-semibold text-foreground">Secrets configurados:</p>
                    <ul className="space-y-2">
                      {[
                        "✅ AZURE_CREDENTIALS",
                        "✅ AZURE_ACR_NAME",
                        "✅ AZURE_ACR_USERNAME",
                        "✅ AZURE_ACR_PASSWORD"
                      ].map((item, i) => (
                        <li key={i} className="text-gray-700">{item}</li>
                      ))}
                    </ul>
                  </div>
                  <p className="text-sm text-gray-600">⏱️ Tempo: 1-2 minutos</p>
                </CardContent>
              </Card>
            </TabsContent>

            <TabsContent value="step3" className="space-y-4">
              <Card>
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <CheckCircle2 className="h-5 w-5 text-green-600" />
                    Deploy das Functions
                  </CardTitle>
                  <CardDescription>Faz build, push e deploy da imagem Docker</CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="bg-gray-900 text-green-400 p-4 rounded-lg font-mono text-sm overflow-x-auto">
                    <div>$ ./3-deploy-functions.sh</div>
                  </div>
                  <div className="space-y-2">
                    <p className="font-semibold text-foreground">O que acontece:</p>
                    <ul className="space-y-2">
                      {[
                        "✅ Build da imagem Docker",
                        "✅ Push para Azure Container Registry",
                        "✅ Deploy no Azure Functions",
                        "✅ Teste automático"
                      ].map((item, i) => (
                        <li key={i} className="text-gray-700">{item}</li>
                      ))}
                    </ul>
                  </div>
                  <p className="text-sm text-gray-600">⏱️ Tempo: 5-10 minutos</p>
                </CardContent>
              </Card>
            </TabsContent>
          </Tabs>
        </div>
      </section>

      {/* Scripts Overview */}
      <section className="py-20 bg-gray-50" id="scripts">
        <div className="container">
          <h2 className="text-4xl font-bold mb-12">Os 4 Scripts Automatizados</h2>
          <img 
            src={scriptsAutomationUrl}
            alt="Scripts Automation"
            className="w-full max-w-md mx-auto rounded-2xl shadow-lg mb-12"
          />
          <div className="grid grid-cols-2 gap-8">
            {[
              {
                name: "1-setup-azure-resources.sh",
                desc: "Cria todos os recursos Azure necessários",
                features: ["Resource Group", "Container Registry", "Storage Account", "Function App"]
              },
              {
                name: "2-configure-github-secrets.sh",
                desc: "Configura secrets do GitHub automaticamente",
                features: ["AZURE_CREDENTIALS", "ACR_NAME", "ACR_USERNAME", "ACR_PASSWORD"]
              },
              {
                name: "3-deploy-functions.sh",
                desc: "Faz build, push e deploy da imagem",
                features: ["Docker Build", "ACR Push", "Deploy", "Teste"]
              },
              {
                name: "4-add-workflows.sh",
                desc: "Adiciona workflows GitHub Actions",
                features: ["CI/CD Automático", "Deploy em Push", "Workflows Prontos"]
              }
            ].map((script, i) => (
              <Card key={i} className="border-gray-200">
                <CardHeader>
                  <CardTitle className="text-lg">{script.name}</CardTitle>
                  <CardDescription>{script.desc}</CardDescription>
                </CardHeader>
                <CardContent>
                  <ul className="space-y-2">
                    {script.features.map((feature, j) => (
                      <li key={j} className="flex items-center gap-2 text-sm text-gray-700">
                        <CheckCircle2 className="h-4 w-4 text-green-600" />
                        {feature}
                      </li>
                    ))}
                  </ul>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Success Section */}
      <section className="py-20 bg-white">
        <div className="container text-center">
          <img 
            src={successDeploymentUrl}
            alt="Successful Deployment"
            className="w-full max-w-md mx-auto rounded-2xl shadow-lg mb-12"
          />
          <h2 className="text-4xl font-bold mb-6">Pronto para Deploy!</h2>
          <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
            Tudo que você precisa está incluído. Download o pacote, execute os 3 scripts e sua Azure Function estará rodando em produção.
          </p>
          <Button size="lg" className="bg-primary hover:bg-primary/90">
            <Download className="mr-2 h-5 w-5" />
            Download Agora
          </Button>
        </div>
      </section>

      {/* FAQ */}
      <section className="py-20 bg-gray-50" id="faq">
        <div className="container max-w-2xl">
          <h2 className="text-4xl font-bold mb-12 text-center">Perguntas Frequentes</h2>
          <div className="space-y-4">
            {[
              {
                q: "Quanto tempo leva para fazer o deploy?",
                a: "Total de 12-23 minutos. Setup Azure (5-10 min), GitHub Secrets (1-2 min), Deploy (5-10 min)."
              },
              {
                q: "O que preciso ter instalado?",
                a: "Docker, GitHub CLI (gh) e uma conta Azure ativa. Azure CLI é instalado automaticamente."
              },
              {
                q: "Posso usar isso em produção?",
                a: "Sim! O deployment inclui monitoramento, logs, CI/CD automático e está pronto para produção."
              },
              {
                q: "Como atualizar o código depois?",
                a: "Simples: git push origin main. GitHub Actions fará o deploy automaticamente."
              }
            ].map((item, i) => (
              <Card key={i} className="border-gray-200">
                <CardHeader>
                  <CardTitle className="text-lg">{item.q}</CardTitle>
                </CardHeader>
                <CardContent>
                  <p className="text-gray-700">{item.a}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-foreground text-white py-12">
        <div className="container">
          <div className="grid grid-cols-3 gap-8 mb-8">
            <div>
              <h3 className="font-bold mb-4">Projeto</h3>
              <ul className="space-y-2 text-sm">
                <li><a href="#" className="hover:text-primary transition">GitHub</a></li>
                <li><a href="#" className="hover:text-primary transition">Documentação</a></li>
                <li><a href="#" className="hover:text-primary transition">Suporte</a></li>
              </ul>
            </div>
            <div>
              <h3 className="font-bold mb-4">Recursos</h3>
              <ul className="space-y-2 text-sm">
                <li><a href="#" className="hover:text-primary transition">Azure Functions</a></li>
                <li><a href="#" className="hover:text-primary transition">Docker</a></li>
                <li><a href="#" className="hover:text-primary transition">GitHub Actions</a></li>
              </ul>
            </div>
            <div>
              <h3 className="font-bold mb-4">Autor</h3>
              <p className="text-sm">Alexandre Pedrosa</p>
              <p className="text-sm text-gray-400">Co-authored by Manus AI</p>
            </div>
          </div>
          <div className="border-t border-gray-700 pt-8 text-center text-sm text-gray-400">
            <p>&copy; 2026 Edge AI App. Todos os direitos reservados.</p>
          </div>
        </div>
      </footer>
    </div>
  );
}
