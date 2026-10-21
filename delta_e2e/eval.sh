#! /bin/bash

python eval.py \
--model_path ${DIFFHLS_DATA}/HLS-Perf-Prediction-with-GNNs/delta_e2e/output/e2e_delta_dsp_20251030_225434/best_e2e_delta_dsp_model.pt \
--ood_design_base_dir ${DIFFHLS_DATA}/Huggingface/wunan_GNN_testbench \
--output_dir ${DIFFHLS_DATA}/HLS-Perf-Prediction-with-GNNs/delta_e2e/output/e2e_delta_dsp_20251030_225434/