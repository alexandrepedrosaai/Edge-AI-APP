import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Download, FileText, Package, Github, ExternalLink } from "lucide-react";

export default function Downloads() {
  return (
    <div className="min-h-screen bg-white">
      {/* Header */}
      <div className="bg-gradient-to-r from-blue-600 to-purple-600 text-white py-12">
        <div className="container">
          <h1 className="text-4xl font-bold mb-4">Downloads</h1>
          <p className="text-lg opacity-90">Todos os arquivos e recursos necessários</p>
        </div>
      </div>

      {/* Main Content */}
      <div className="container py-12">
        <div className="grid grid-cols-2 gap-8">
          {/* Main Package */}
          <Card className="col-span-2 border-2 border-primary">
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Package className="h-6 w-6 text-primary" />
                Pacote Completo de Deploy
              </CardTitle>
              <CardDescription>Tudo que você precisa para fazer deploy</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="bg-blue-50 p-4 rounded-lg">
                <p className="font-semibold mb-2">edge-ai-deploy-completo.zip (17 KB)</p>
                <p className="text-sm text-gray-700 mb-4">
                  Contém 4 scripts automatizados, documentação completa e workflows GitHub Actions.
                </p>
                <Button className="bg-primary hover:bg-primary/90">
                  <Download className="mr-2 h-4 w-4" />
                  Download Agora
                </Button>
              </div>
              <div className="space-y-2">
                <h4 className="font-semibold">Incluído no pacote:</h4>
                <ul className="space-y-1 text-sm text-gray-700">
                  <li>✅ 1-setup-azure-resources.sh</li>
                  <li>✅ 2-configure-github-secrets.sh</li>
                  <li>✅ 3-deploy-functions.sh</li>
                  <li>✅ 4-add-workflows.sh</li>
                  <li>✅ README.md (documentação completa)</li>
                  <li>✅ GUIA-RAPIDO.md (quick start)</li>
                  <li>✅ Workflows GitHub Actions</li>
                </ul>
              </div>
            </CardContent>
          </Card>

          {/* Documentation */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <FileText className="h-5 w-5" />
                Documentação
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <h4 className="font-semibold mb-2">README.md</h4>
                <p className="text-sm text-gray-700 mb-3">Documentação completa com troubleshooting</p>
                <Button variant="outline" size="sm">
                  <Download className="mr-2 h-4 w-4" />
                  Download
                </Button>
              </div>
              <div>
                <h4 className="font-semibold mb-2">GUIA-RAPIDO.md</h4>
                <p className="text-sm text-gray-700 mb-3">Quick start em 3 passos</p>
                <Button variant="outline" size="sm">
                  <Download className="mr-2 h-4 w-4" />
                  Download
                </Button>
              </div>
            </CardContent>
          </Card>

          {/* Repository */}
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <Github className="h-5 w-5" />
                Repositório
              </CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <h4 className="font-semibold mb-2">Edge-AI-APP</h4>
                <p className="text-sm text-gray-700 mb-3">Repositório principal com o código-fonte</p>
                <Button variant="outline" size="sm">
                  <ExternalLink className="mr-2 h-4 w-4" />
                  Abrir no GitHub
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
