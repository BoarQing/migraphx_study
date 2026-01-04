```mermaid
flowchart TD
    A[ONNX Runtime]
    B[MigraphX Execution Provider]
    C[GetCapability]
    D[Compile]
    E[.mxr]

    A --> B
    B --> C
    C --> D
    D --> E
```