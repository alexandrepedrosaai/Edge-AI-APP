import torch
import torch.nn as nn

class MiniLLM(nn.Module):
    def __init__(self, vocab_size=1000, hidden_dim=128):
        super(MiniLLM, self).__init__()
        self.embed = nn.Embedding(vocab_size, hidden_dim)
        self.fc = nn.Linear(hidden_dim, vocab_size)

    def forward(self, input_ids):
        x = self.embed(input_ids)
        x = x.mean(dim=1)  # pooling simples
        return self.fc(x)

def build_model():
    return MiniLLM()
