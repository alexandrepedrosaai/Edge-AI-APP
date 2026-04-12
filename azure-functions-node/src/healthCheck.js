const { app } = require('@azure/functions');

/**
 * Edge AI App - Health Check Function
 * Returns the health status of the Edge AI App
 */
app.http('HealthCheck', {
    methods: ['GET'],
    authLevel: 'anonymous',
    route: 'health',
    handler: async (request, context) => {
        context.log('Health check requested.');

        return {
            status: 200,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                status: 'healthy',
                app: 'Edge-AI-APP',
                version: '1.0.0',
                runtime: 'Azure Functions v4 (Node.js)',
                timestamp: new Date().toISOString(),
                uptime: process.uptime()
            }, null, 2)
        };
    }
});
