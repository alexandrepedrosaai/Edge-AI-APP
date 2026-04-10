using System;

namespace EdgeAIApp
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Edge-AI-APP in C#: initializing...");
            
            // Example call to the ML/DL module
            MLRunner runner = new MLRunner();
            runner.RunModel();

            Console.WriteLine("Execution completed.");
        }
    }
}
