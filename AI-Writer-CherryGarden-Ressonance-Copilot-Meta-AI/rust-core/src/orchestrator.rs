use crate::performance;

pub fn handle_request(prompt: &str) {
    println!("[Orchestration] Managing enterprise logic...");
    println!("[Orchestration] Delegating to performance engine...");
    performance::run_instances(prompt);
}
