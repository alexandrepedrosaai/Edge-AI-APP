// websocket.js - integração com commits GitHub
export function initWebSocket() {
  const ws = new WebSocket('wss://example.com/commits');

  ws.onopen = () => {
    console.log("WebSocket conectado.");
    ws.send(JSON.stringify({ action: "subscribe", topic: "Edge-AI-APP" }));
  };

  ws.onmessage = (event) => {
    const data = JSON.parse(event.data);
    console.log("Commit recebido:", data);
    updateDashboard(data);
  };

  ws.onclose = () => {
    console.log("WebSocket desconectado.");
  };

  ws.onerror = (error) => {
    console.error("Erro WebSocket:", error);
  };
}

function updateDashboard(commitData) {
  const canvas = document.getElementById('dashboard');
  const ctx = canvas.getContext('2d');
  ctx.fillStyle = 'yellow';
  ctx.fillText(`Commit: ${commitData.message}`, 10, 150);
}
