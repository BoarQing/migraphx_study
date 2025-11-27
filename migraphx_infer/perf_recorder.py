import os
import subprocess
import argparse
import json
from pathlib import Path


def get_model_list(directory):
    ret = []
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".onnx"):
                ret.append(Path(directory) / file)
    return ret

def get_output_dir():
    dir = Path(os.getcwd()) / "result"
    os.makedirs(dir, exist_ok=True)
    return dir

def run(cmd, f, dir):
    filename = os.path.basename(f)
    log_file = filename.replace(".onnx", ".log")
    log_file_path = dir / log_file

    cmd = [cmd, "-e", "migraphx", "-I", "-s", str(f)]
    print(f"running model {filename}")
    with open(log_file_path, "w", encoding="utf-8") as log:
        try:
            subprocess.run(cmd, check=True, text=True, stdout=log, stderr=log, timeout=1800)
            print(f"{filename} run finished")
        except Exception as e:
            print(f"{filename} run failed")
            log.write(str(e))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--directory")
    parser.add_argument("--perf_test_cmd")

    args = parser.parse_args()
    lst = get_model_list(args.directory)
    dir = get_output_dir()
    for f in lst:
        run(args.perf_test_cmd, f, dir)


if __name__ == "__main__":
    main()
