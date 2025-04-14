<img src="./assets/logo.svg" width="300px">

> Run LLMs inside a PDF file.

Watch how llm.pdf was built [on YouTube](https://youtu.be/4cBom2lAx-g).

## What is llm.pdf?

This is a proof-of-concept project, showing that it's possible to run an entire Large Language Model in nothing but a PDF file.

It uses [Emscripten](https://emscripten.org/) to compile [llama.cpp](https://github.com/ggml-org/llama.cpp?tab=readme-ov-file) into [asm.js](https://en.wikipedia.org/wiki/Asm.js), which can then be run in the PDF using an old PDF JS injection.

Combined with embedding the entire LLM file into the PDF with base64, we are able to run LLM inference in nothing but a PDF.

[Watch the video on YouTube](https://youtu.be/4cBom2lAx-g) to learn the full story!

## Load a Custom Model in the PDF

The `scripts/generatePDF.py` file will help you create a PDF with any compatible LLM.

The easiest way to get started is with the following command:
```sh
cd scripts
python3 generatePDF.py --model "path/for/model.gguf" --output "path/to/output.pdf"
```

### Choosing a Model

Here's the general guidelines when picking a model:

* Only GGUF quantized models work.
* Generally, try to use Q8 quantized models, as those run the fastest.
* For reference, 135M parameter models take around 5s per token input/output. Anything higher will likely be unreasonably slow.

## Inspiration and Credits

Thank you to the following for inspiration and reference:
* [ading2210's DoomPDF](https://github.com/ading2210/doompdf)
* [rahuldshetty's llm.js](https://github.com/rahuldshetty/llm.js)

Thank you to the following for creating the tiny LLMs that power llm.pdf:
* [EleutherAI's pythia models](https://github.com/EleutherAI/pythia)
* [Ronen Eldan and Yuanzhi Li's TinyStories LLM](https://arxiv.org/abs/2305.07759)
* [arnir0's Tiny-LLM](https://arxiv.org/abs/2305.07759)