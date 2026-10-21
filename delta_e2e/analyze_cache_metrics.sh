#! /bin/bash

python analyze_cache_metrics.py \
  --kernel_base_dir ${DIFFHLS_DATA}/Huggingface/forgehls_kernels  \
  --design_base_dir ${DIFFHLS_DATA}/Huggingface/forgehls_PolyBench_part_370designs \
  --cache_root graph_cache