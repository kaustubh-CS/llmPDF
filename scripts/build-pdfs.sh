process_model() {
    local model_repo="$1"
    local model_file="$2"
    local new_name="$3"
    local file_name="$4"
    if [ ! -f "../models/$new_name" ]; then
        huggingface-cli download "$model_repo" "$model_file" --local-dir "../models" --local-dir-use-symlinks False
        mv "../models/$model_file" "../models/$new_name"
    else
        echo "models/$new_name exists, skipping download"
    fi
    python3 ./generatePDF.py --model "../models/$new_name" --output "../builds/$file_name"
}

if [ -d "../builds" ]; then
    rm -rf "../builds"
fi
mkdir ../builds
process_model \
    "tensorblock/Pythia-31M-Chat-v1-GGUF" \
    "Pythia-31M-Chat-v1-Q8_0.gguf" \
    "pythia-chat-31M-q8.gguf" \
    "pythia-llm.pdf"
process_model \
    "Felladrin/gguf-SmolLM-135M-Instruct" \
    "SmolLM-135M-Instruct.Q8_0.gguf" \
    "smollm-it-135M-q8.gguf" \
    "smollm-llm.pdf"
process_model \
    "mradermacher/Tiny-LLM-GGUF" \
    "Tiny-LLM.Q8_0.gguf" \
    "tinyllm-10M-q8.gguf" \
    "tinyllm-llm.pdf"
process_model \
    "afrideva/Tinystories-gpt-0.1-3m-GGUF" \
    "tinystories-gpt-0.1-3m.Q8_0.gguf" \
    "tinystories-3M-q8.gguf" \
    "tinystories-llm.pdf"
