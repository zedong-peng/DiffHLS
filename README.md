# DiffHLS: Differential Learning for High-Level Synthesis QoR Prediction

Code for the ISEDA 2026 paper *DiffHLS: Differential Learning for High-Level Synthesis QoR Prediction with GNNs and LLM Code Embeddings*.

HLS compiles C/C++ to RTL, but pragma-driven design-space exploration is expensive because every design point needs a synthesis run. DiffHLS predicts QoR from **kernel–design pairs**: a kernel baseline and a pragma-inserted variant of the same kernel. Instead of regressing absolute targets, it predicts the kernel baseline and the design-induced delta separately, and sums them. Each side is encoded by its own GNN branch, and the delta pathway also sees code embeddings from a pretrained code LLM.

- Paper: [arXiv:2604.09240](https://arxiv.org/abs/2604.09240) · ISEDA 2026
- Dataset: [ForgeHLS](https://github.com/zedong-peng/ForgeHLS) · [Hugging Face](https://huggingface.co/datasets/zedongpeng/forgehls)

## Layout

| Path | Contents |
| --- | --- |
| `delta_e2e/` | DiffHLS itself: paired dataset construction, dual-branch GNN with baseline/delta heads, LLM code embedding, evaluation |
| `delta_e2e/gen/` | Graph-diffusion variant for QoR prediction on generated designs |
| `GNN/` | Single-graph QoR prediction benchmark (PNA, GraphSAGE, GAT, GCN, GIN, R-GCN, ...) used for the backbone comparison table |
| `graph_as_token/` | Baseline that serialises the IR graph as LLM input tokens |
| `LLM_as_predictor/` | Baseline that fine-tunes a code LLM to predict QoR directly |
| `Graphs/` | Graph construction from Vitis `.autopilot/db/*.adb` and `csynth.xml` |

## Setup

```bash
pip install torch torch-geometric pandas numpy tqdm matplotlib optuna swanlab transformers
bash install_pyg.sh          # only if torch-geometric needs a matching wheel
```

Paths to the data are read from two environment variables; nothing is hard-coded:

```bash
export DIFFHLS_DATA=/path/to/data        # see the layout below
export DIFFHLS_MODEL=Qwen/Qwen2.5-Coder-1.5B-Instruct   # or a local checkpoint
```

`DIFFHLS_DATA` is expected to contain:

```
Huggingface/forgehls_lite_10designs/    # 10-design paired set (smoke tests)
Huggingface/forgehls_lite_100designs/   # 100-design paired set (main experiments)
Huggingface/forgehls_benchmark/         # OOD benchmark designs
Huggingface/forgehls_kernels/           # kernel sources
Huggingface/forgehls_PolyBench_part_500designs/
HLSBatchProcessor/data/designs/         # raw design dumps
HLS-Perf-Prediction-with-GNNs/          # checkout providing Graphs/forgehls_kernels
```

The design dumps themselves come from the [ForgeHLS](https://huggingface.co/datasets/zedongpeng/forgehls) release.

## Running

Smoke test on ten designs:

```bash
cd delta_e2e
bash run_10designs_build_graph.sh     # build IR graphs and cache them
bash run_10designs.sh                 # train + evaluate the pair model
```

Main experiments on a hundred designs:

```bash
bash run_100designs_build_graph_hon.sh   # or _hoff.sh for the other flow
bash run_100designs_exp1.sh              # baseline vs. delta heads
bash run_100designs_exp2.sh              # with / without LLM code embeddings
bash run_100designs_exp3.sh              # full model, all targets
bash run_100designs_exp3_optuna.sh       # hyper-parameter search
```

Backbone comparison lives in `GNN/`, for example:

```bash
cd GNN
bash train_pna.sh                        # pna / sage / gat / gcn / gin variants
```

Every script takes its paths as CLI flags with the environment-variable defaults above, so overriding a single run only needs `--design_base_dir ...`.

## Citing

```bibtex
@inproceedings{peng2026diffhls,
  title     = {DiffHLS: Differential Learning for High-Level Synthesis QoR Prediction with GNNs and LLM Code Embeddings},
  author    = {Peng, Zedong and Li, Zeju and Xu, Qiang and Zhao, Jieru},
  booktitle = {IEEE/ACM International Symposium of EDA (ISEDA)},
  year      = {2026}
}
```

The `GNN/` benchmark derives from [lydiawunan/HLS-Perf-Prediction-with-GNNs](https://github.com/lydiawunan/HLS-Perf-Prediction-with-GNNs) (DAC 2022), with the ForgeHLS data pipeline added; MIT licensed, see `LICENSE`.
