#!/usr/bin/env bash
conda activate feb
python scripts/exp.py --exp_root checkpoints --not_dryrun --model_vals allenai/unifiedqa-t5-base,allenai/unifiedqa-t5-large,allenai/unifiedqa-t5-3b --dataset_vals sbic --n_gpus 4
python scripts/exp.py --exp_root checkpoints --collect_results
