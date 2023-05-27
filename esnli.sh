#!/bin/sh
#SBATCH --partition=ILCC_GPU
#SBATCH --gres=gpu:4
#SBATCH --mem=32000  # memory in Mb
#SBATCH --time=0-80:00:00

export CUDA_HOME=/opt/cuda-9.0.176.1/

export CUDNN_HOME=/opt/cuDNN-7.0/

export STUDENT_ID=$(whoami)

export LD_LIBRARY_PATH=${CUDNN_HOME}/lib64:${CUDA_HOME}/lib64:$LD_LIBRARY_PATH

export LIBRARY_PATH=${CUDNN_HOME}/lib64:$LIBRARY_PATH

export CPATH=${CUDNN_HOME}/include:$CPATH

export PATH=${CUDA_HOME}/bin:${PATH}

export PYTHON_PATH=$PATH

# mkdir -p /disk/scratch/${STUDENT_ID}


# export TMPDIR=/disk/scratch/${STUDENT_ID}/
# export TMP=/disk/scratch/${STUDENT_ID}/

# mkdir -p ${TMP}/datasets/
# export DATASET_DIR=${TMP}/datasets/
# Activate the relevant virtual environment:

source /home/${STUDENT_ID}/miniconda3/bin/activate feb
# cd ..
# python train_evaluate_emnist_classification_system.py --filepath_to_arguments_json_file experiment_configs/emnist_tutorial_config.json
# #!/usr/bin/env bash
# conda activate feb
python scripts/exp.py --exp_root checkpoints --not_dryrun --model_vals allenai/unifiedqa-t5-base,allenai/unifiedqa-t5-large,allenai/unifiedqa-t5-3b --dataset_vals esnli --n_gpus 4
# python scripts/exp.py --exp_root checkpoints --collect_results
