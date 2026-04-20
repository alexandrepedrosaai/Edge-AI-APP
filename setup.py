from setuptools import setup, find_packages

setup(
    name="edge-ai-app",
    version="1.0.0",
    packages=find_packages(),
    install_requires=[
        "numpy",
        "torch",
        "onnx",
        "slack_sdk",
        "pytest",
    ],
    author="Alexandre Pedrosa",
    description="Edge AI App with Q-Learning and Orbital Simulations",
)
