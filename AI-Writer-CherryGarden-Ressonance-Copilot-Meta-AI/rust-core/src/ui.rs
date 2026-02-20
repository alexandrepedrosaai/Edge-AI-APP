use crate::orchestrator;

pub fn send_request(prompt: &str) {
    println!("[UI] User submitted prompt: {}", prompt);
    orchestrator::handle_request(prompt);
}
