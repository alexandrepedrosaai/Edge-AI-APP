import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { AlertCircle, CheckCircle2, Code2, FileText, Terminal } from "lucide-react";

export default function Documentation() {
  return (
    <div className="min-h-screen bg-white">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-600 to-purple-600 text-white py-12">
        <div className="container">
          <h1 className="text-4xl font-bold mb-4">Documentação Completa</h1>
          <p className="text-lg opacity-90">Guias detalhados para cada etapa do deployment</p>
        </div>
      </div>

      {/* Main Content */}
      <div className="container py-12">
        <div className="grid grid-cols-3 gap-8">
          {/* Sidebar */}
          <div className="col-span-1">
            <div className="sticky top-20">
              <div className="bg-gray-50 rounded-lg p-6">
                <h3 className="font-bold mb-4">Índice</h3>
                <ul className="space-y-3 text-sm">
                  <li><a href="#intro" className="text-primary hover:underline">Introdução</a></li>
                  <li><a href="#prereqs" className="text-primary hover:underline">Pré-requisitos</a></li>
                  <li><a href="#setup" className="text-primary hover:underline">Setup Azure</a></li>
                  <li><a href="#github" className="text-primary hover:underline">GitHub Secrets</a></li>
                  <li><a href="#deploy" className="text-primary hover:underline">Deploy</a></li>
                  <li><a href="#testing" className="text-primary hover:underline">Testes</a></li>
                  <li><a href="#troubleshooting" className="text-primary hover:underline">Troubleshooting</a></li>
                </ul>
              </div>
            </div>
          </div>

          {/* Content */}
          <div className="col-span-2 space-y-8">
            {/* Introduction */}
            <section id="intro">
              <h2 className="text-3xl font-bold mb-4">Introdução</h2>
              <p className="text-gray-700 mb-4">
                Este guia fornece instruções detalhadas para fazer deploy do Edge AI App no Azure usando Azure Functions com Docker.
              </p>
              <Card>
                <CardHeader>
                  <CardTitle>O que você vai aprender</CardTitle>
                </CardHeader>
                <CardContent className="space-y-2">
                  <p className="flex items-center gap-2">
                    <CheckCircle2 className="h-5 w-5 text-green-600" />
                    Como criar recursos Azure automaticamente
                  </p>
                  <p className="flex items-center gap-2">
                    <CheckCircle2 className="h-5 w-5 text-green-600" />
                    Como configurar CI/CD com GitHub Actions
                  </p>
                  <p className="flex items-center gap-2">
                    <CheckCircle2 className="h-5 w-5 text-green-600" />
                    Como fazer deploy de containers Docker
                  </p>
                  <p className="flex items-center gap-2">
                    <CheckCircle2 className="h-5 w-5 text-green-600" />
                    Como monitorar e testar seu deployment
                  </p>
                </CardContent>
              </Card>
            </section>

            {/* Prerequisites */}
            <section id="prereqs">
              <h2 className="text-3xl font-bold mb-4">Pré-requisitos</h2>
              <div className="space-y-4">
                <Card>
                  <CardHeader>
                    <CardTitle className="text-lg">Instalações Necessárias</CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-4">
                    <div>
                      <h4 className="font-semibold mb-2">Docker</h4>
                      <p className="text-gray-700 mb-3">Necessário para build das imagens</p>
                      <div className="bg-gray-100 p-3 rounded text-sm font-mono">
                        docker --version
                      </div>
                    </div>
                    <div>
                      <h4 className="font-semibold mb-2">GitHub CLI (gh)</h4>
                      <p className="text-gray-700 mb-3">Para configurar secrets do GitHub</p>
                      <div className="bg-gray-100 p-3 rounded text-sm font-mono">
                        # Ubuntu/Debian<br />
                        sudo apt install gh<br />
                        <br />
                        # macOS<br />
                        brew install gh
                      </div>
                    </div>
                    <div>
                      <h4 className="font-semibold mb-2">Git</h4>
                      <p className="text-gray-700 mb-3">Para clonar o repositório</p>
                      <div className="bg-gray-100 p-3 rounded text-sm font-mono">
                        git --version
                      </div>
                    </div>
                  </CardContent>
                </Card>

                <Card>
                  <CardHeader>
                    <CardTitle className="text-lg">Contas Necessárias</CardTitle>
                  </CardHeader>
                  <CardContent className="space-y-3">
                    <p className="flex items-center gap-2">
                      <CheckCircle2 className="h-5 w-5 text-green-600" />
                      Conta Azure ativa com permissões
                    </p>
                    <p className="flex items-center gap-2">
                      <CheckCircle2 className="h-5 w-5 text-green-600" />
                      Conta GitHub com acesso ao repositório
                    </p>
                  </CardContent>
                </Card>
              </div>
            </section>

            {/* Setup Azure */}
            <section id="setup">
              <h2 className="text-3xl font-bold mb-4">1. Setup Azure Resources</h2>
              <Card>
                <CardHeader>
                  <CardTitle>Executar o Script de Setup</CardTitle>
                  <CardDescription>Cria todos os recursos necessários no Azure</CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="bg-gray-900 text-green-400 p-4 rounded font-mono text-sm overflow-x-auto">
                    ./1-setup-azure-resources.sh
                  </div>
                  <div>
                    <h4 className="font-semibold mb-2">O script fará:</h4>
                    <ul className="space-y-2">
                      {[
                        "Verificar/instalar Azure CLI",
                        "Fazer login no Azure",
                        "Criar Resource Group",
                        "Criar Azure Container Registry (ACR)",
                        "Criar Storage Account",
                        "Criar App Service Plan",
                        "Criar Function App",
                        "Criar Service Principal",
                        "Configurar Application Insights"
                      ].map((item, i) => (
                        <li key={i} className="flex items-center gap-2">
                          <CheckCircle2 className="h-4 w-4 text-green-600" />
                          {item}
                        </li>
                      ))}
                    </ul>
                  </div>
                  <div className="bg-blue-50 border border-blue-200 rounded p-4">
                    <p className="flex items-start gap-2 text-sm">
                      <AlertCircle className="h-5 w-5 text-blue-600 flex-shrink-0 mt-0.5" />
                      <span>
                        O script gerará dois arquivos: <code className="bg-white px-2 py-1 rounded">azure-config.env</code> e <code className="bg-white px-2 py-1 rounded">azure-credentials.json</code>. Guarde-os com segurança!
                      </span>
                    </p>
                  </div>
                </CardContent>
              </Card>
            </section>

            {/* GitHub Secrets */}
            <section id="github">
              <h2 className="text-3xl font-bold mb-4">2. Configurar GitHub Secrets</h2>
              <Card>
                <CardHeader>
                  <CardTitle>Executar o Script de Secrets</CardTitle>
                  <CardDescription>Configura secrets do GitHub automaticamente</CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="bg-gray-900 text-green-400 p-4 rounded font-mono text-sm overflow-x-auto">
                    ./2-configure-github-secrets.sh
                  </div>
                  <div>
                    <h4 className="font-semibold mb-2">Secrets configurados:</h4>
                    <ul className="space-y-2">
                      {[
                        "AZURE_CREDENTIALS - Credenciais do Service Principal",
                        "AZURE_ACR_NAME - Nome do Azure Container Registry",
                        "AZURE_ACR_USERNAME - Username do ACR",
                        "AZURE_ACR_PASSWORD - Password do ACR"
                      ].map((item, i) => (
                        <li key={i} className="flex items-center gap-2 text-sm">
                          <CheckCircle2 className="h-4 w-4 text-green-600" />
                          {item}
                        </li>
                      ))}
                    </ul>
                  </div>
                </CardContent>
              </Card>
            </section>

            {/* Deploy */}
            <section id="deploy">
              <h2 className="text-3xl font-bold mb-4">3. Deploy das Functions</h2>
              <Card>
                <CardHeader>
                  <CardTitle>Executar o Script de Deploy</CardTitle>
                  <CardDescription>Faz build, push e deploy da imagem Docker</CardDescription>
                </CardHeader>
                <CardContent className="space-y-4">
                  <div className="bg-gray-900 text-green-400 p-4 rounded font-mono text-sm overflow-x-auto">
                    ./3-deploy-functions.sh
                  </div>
                  <div>
                    <h4 className="font-semibold mb-2">O script fará:</h4>
                    <ul className="space-y-2">
                      {[
                        "Clonar/atualizar o repositório",
                        "Fazer login no Azure e ACR",
                        "Build da imagem Docker",
                        "Push para Azure Container Registry",
                        "Configurar Function App com a imagem",
                        "Testar o deployment"
                      ].map((item, i) => (
                        <li key={i} className="flex items-center gap-2">
                          <CheckCircle2 className="h-4 w-4 text-green-600" />
                          {item}
                        </li>
                      ))}
                    </ul>
                  </div>
                </CardContent>
              </Card>
            </section>

            {/* Testing */}
            <section id="testing">
              <h2 className="text-3xl font-bold mb-4">Testando o Deployment</h2>
              <Card>
                <CardHeader>
                  <CardTitle>Teste Manual</CardTitle>
                </CardHeader>
                <CardContent className="space-y-4">
                  <p>Após o deployment, teste sua Function:</p>
                  <div className="bg-gray-900 text-green-400 p-4 rounded font-mono text-sm overflow-x-auto">
                    <div># Carregar configuração</div>
                    <div>source azure-config.env</div>
                    <div></div>
                    <div># Testar HTTP Trigger</div>
                    <div>curl "https://$FUNCTION_APP_NAME.azurewebsites.net/api/HttpTrigger?name=Alexandre"</div>
                  </div>
                  <div>
                    <h4 className="font-semibold mb-2">Resposta esperada:</h4>
                    <div className="bg-gray-100 p-4 rounded font-mono text-sm">
                      {`{
  "status": "success",
  "message": "Hello, Alexandre! Edge AI App is running.",
  "app": "Edge-AI-APP",
  "version": "1.0.0",
  "author": "Alexandre Pedrosa"
}`}
                    </div>
                  </div>
                </CardContent>
              </Card>
            </section>

            {/* Troubleshooting */}
            <section id="troubleshooting">
              <h2 className="text-3xl font-bold mb-4">Troubleshooting</h2>
              <div className="space-y-4">
                {[
                  {
                    problem: "Docker não está rodando",
                    solution: "sudo systemctl start docker && sudo usermod -aG docker $USER"
                  },
                  {
                    problem: "GitHub CLI não encontrado",
                    solution: "sudo apt install gh (Ubuntu/Debian) ou brew install gh (macOS)"
                  },
                  {
                    problem: "Function não responde",
                    solution: "Aguarde 3-5 minutos. O container pode demorar para iniciar. Verifique logs com: az functionapp log tail"
                  },
                  {
                    problem: "Erro de permissão no Azure",
                    solution: "Verifique se sua conta Azure tem permissões suficientes na subscription"
                  }
                ].map((item, i) => (
                  <Card key={i}>
                    <CardHeader>
                      <CardTitle className="text-lg">{item.problem}</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="bg-gray-100 p-3 rounded font-mono text-sm">
                        {item.solution}
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </section>
          </div>
        </div>
      </div>
    </div>
  );
}
