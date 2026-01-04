```mermaid
flowchart TD
    A[Cache Check]
    B[parse_onnx_buffer]
    C[Quantization Pipeline]
    D[MIGraphX run_passes]
    E[Cache Save]

    A --> B
    B --> C
    C --> D
    D --> E
```