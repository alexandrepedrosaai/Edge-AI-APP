use crate::ai_bridge;

pub fn run_instances(prompt: &str) {
    println!("[Performance] Running parallel instances...");

    for i in 1..=3 {
        println!("[Performance] Instance #{} active", i);
    }

    println!("[Performance] Calling AI core...");
    ai_bridge::call_ai(prompt);
}
