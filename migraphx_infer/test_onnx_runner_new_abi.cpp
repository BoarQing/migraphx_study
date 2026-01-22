#include <iostream>
#include <onnxruntime_cxx_api.h>
#include <random>
#include <filesystem>
#include <vector>

int main(int argc, char *argv[]) {
  if (argc < 3) {
    std::cerr << "Usage: " << argv[0] << " <model_path.onnx> <lib_path>" << std::endl;
    return 1;
  }

  Ort::Env env(ORT_LOGGING_LEVEL_INFO, "test_onnx_runner");
  Ort::SessionOptions session_options;
  session_options.SetLogSeverityLevel(0); 
  session_options.SetLogId("session_logger");
  std::string ep_name = "magic";

  std::vector<Ort::ConstEpDevice> devices;
  auto lib_path = std::filesystem::path(argv[2]);
  if (!std::filesystem::exists(lib_path)) {
    std::cout<<"lib path does not exists" << lib_path << std::endl;
    exit(0);
  }
  Ort::GetApi().RegisterExecutionProviderLibrary(env, ep_name.c_str(), lib_path.c_str());

  auto options = std::unordered_map<std::string, std::string>();
  session_options.AppendExecutionProvider_V2(env, devices, options);
  Ort::AllocatorWithDefaultOptions allocator;
    const char *model_path = argv[1];
  std::cout << "Loading model: " << model_path << std::endl;
  Ort::Session session(env, model_path, session_options);
  size_t num_inputs = session.GetInputCount();
  std::cout << "Number of inputs: " << num_inputs << std::endl;

  Ort::AllocatedStringPtr input_name_ptr =
      session.GetInputNameAllocated(0, allocator);
  const char *input_name = input_name_ptr.get();
  std::cout << "Input name: " << input_name << std::endl;

  Ort::TypeInfo input_type_info = session.GetInputTypeInfo(0);
  auto tensor_info = input_type_info.GetTensorTypeAndShapeInfo();
  auto input_shape = tensor_info.GetShape();
  auto input_type = tensor_info.GetElementType();

  std::cout << "Input shape: [ ";
  for (auto dim : input_shape) {
    std::cout << dim << " ";
  }
  std::cout << "]" << std::endl;

  for (auto &dim : input_shape) {
    if (dim <= 0) {
      dim = 1;
    }
  }

  size_t input_tensor_size = 1;
  for (auto dim : input_shape) {
    input_tensor_size *= dim;
  }

  std::cout << "Total elements: " << input_tensor_size << std::endl;

  std::vector<float> input_tensor_values(input_tensor_size);
  std::mt19937 rng(std::random_device{}());
  std::uniform_real_distribution<float> dist(0.0f, 1.0f);
  for (auto &v : input_tensor_values) {
    v = dist(rng);
  }

  Ort::MemoryInfo memory_info =
      Ort::MemoryInfo::CreateCpu(OrtDeviceAllocator, OrtMemTypeCPU);

  Ort::Value input_tensor = Ort::Value::CreateTensor<float>(
      memory_info, input_tensor_values.data(), input_tensor_values.size(),
      input_shape.data(), input_shape.size());

  const char *input_names[] = {input_name};
  size_t num_outputs = session.GetOutputCount();
  Ort::AllocatedStringPtr output_name_ptr =
      session.GetOutputNameAllocated(0, allocator);
  const char *output_name = output_name_ptr.get();
  std::cout << "Output name: " << output_name << std::endl;
  const char *output_names[] = {output_name};

  int infer_count = 1;
  if (argc >= 3) {
    infer_count = std::atoi(argv[2]);
  }
  std::vector<Ort::Value> output_tensors; 
  for (int i = 0; i < infer_count; ++i) {
    std::cout<<"At iteration:" << i <<std::endl;
    output_tensors = session.Run(Ort::RunOptions{nullptr}, input_names,
                                    &input_tensor, 1, output_names, 1);
  }
  float *output_data = output_tensors.front().GetTensorMutableData<float>();
  auto output_info = output_tensors.front().GetTensorTypeAndShapeInfo();
  auto output_shape = output_info.GetShape();

  std::cout << "Output shape: [ ";
  for (auto dim : output_shape)
    std::cout << dim << " ";
  std::cout << "]" << std::endl;

  std::cout << "First few output values: ";
  for (int i = 0; i < std::min<size_t>(5, output_info.GetElementCount()); i++)
    std::cout << output_data[i] << " ";
  std::cout << std::endl;

  return 0;
}