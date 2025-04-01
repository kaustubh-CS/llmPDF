<img src="./assets/logo.svg" width="200px">

> Run LLMs inside a PDF file.

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

This was inspired originally by [ading2210's DoomPDF](https://github.com/ading2210/doompdf), and it's source inpsired many of the compilation flags for llm.pdf.

Thank you to [rahuldshetty's llm.js](https://github.com/rahuldshetty/llm.js) for providing the original idea of compiling llama.cpp into JS.

Shoutout to Pythia [EleutherAI's pythia models](https://github.com/EleutherAI/pythia), [Ronen Eldan and Yuanzhi Li's TinyStories LLM](https://arxiv.org/abs/2305.07759), as well as [arnir0's Tiny-LLM](https://arxiv.org/abs/2305.07759) for providing the small LLMs that power llm.pdf.