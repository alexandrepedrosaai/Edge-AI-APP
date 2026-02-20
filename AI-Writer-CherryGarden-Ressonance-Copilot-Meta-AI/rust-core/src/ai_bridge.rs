use std::process::Command;

pub fn call_ai(prompt: &str) {
    println!("[AI Bridge] Sending prompt to Python AI core...");

    let output = Command::new("python")
        .arg("python-core/ai_core.py")
        .arg(prompt)
        .output()
        .expect("Failed to execute Python AI core");

    println!("[AI Bridge] Response from AI core:");
    println!("{}", String::from_utf8_lossy(&output.stdout));
}
