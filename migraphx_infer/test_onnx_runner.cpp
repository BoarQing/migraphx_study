#include <iostream>
#include <vector>
#include <onnxruntime_cxx_api.h>

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <model_path.onnx>" << std::endl;
        return 1;
    }

    Ort::Env env(ORT_LOGGING_LEVEL_WARNING, "test_onnx_runner");
    Ort::SessionOptions session_options;
    Ort::ThrowOnError(OrtSessionOptionsAppendExecutionProvider_MIGraphX(session_options, 0));

    const char* model_path = argv[1];
    std::cout << "Loading model: " << model_path << std::endl;
    Ort::Session session(env, model_path, session_options);
    Ort::AllocatorWithDefaultOptions allocator;
    size_t num_inputs = session.GetInputCount();
    std::cout << "Number of inputs: " << num_inputs << std::endl;

    return 0;
}