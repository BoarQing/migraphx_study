```mermaid
flowchart TD
    A[Ubuntu Setup/WSL Setup]
    B[Install ROCm]
    C[Build MIGraphX]
    D[Build ONNX Runtime with MIGraphX EP]
    E[Run inference]

    A --> B
    B --> C
    C --> D
    D --> E
```