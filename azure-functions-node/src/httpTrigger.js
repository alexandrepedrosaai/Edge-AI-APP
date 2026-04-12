const { app } = require('@azure/functions');

/**
 * Edge AI App - HTTP Trigger Function
 * Handles HTTP GET and POST requests for Edge AI processing
 */
app.http('HttpTrigger', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        context.log('Edge AI App HTTP trigger function processed a request.');

        // Get name from query string or request body
        let name = request.query.get('name');

        if (!name) {
            try {
                const body = await request.json();
                name = body && body.name;
            } catch (e) {
                // No JSON body
            }
        }

        if (name) {
            return {
                status: 200,
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    status: 'success',
                    message: `Hello, ${name}! Edge AI App is running.`,
                    app: 'Edge-AI-APP',
                    version: '1.0.0',
                    author: 'Alexandre Pedrosa',
                    timestamp: new Date().toISOString()
                }, null, 2)
            };
        }

        return {
            status: 400,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                status: 'error',
                message: 'Please pass a name on the query string or in the request body',
                usage: '?name=YourName or POST with JSON body {"name": "YourName"}'
            }, null, 2)
        };
    }
});
