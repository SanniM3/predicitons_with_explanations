#!/bin/sh
#SBATCH --partition=PGR-Standard
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:8
#SBATCH --mem-per-gpu=128000
#SBATCH --time=0-100:00:00


# Get the current array index
# CURRENT_INDEX=$SLURM_ARRAY_TASK_ID
# FULL_JOB_ID="${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}"
FULL_JOB_ID = $SLURM_JOB_ID

# Set the default parameter values
# n_current_token=$((CURRENT_INDEX * 10))



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
echo "Your script for $FULL_JOB_ID has started running" | mail -s "Script Starting Alert" s2421110@ed.ac.uk
# python scripts/exp.py --exp_root checkpoints --not_dryrun --model_vals allenai/unifiedqa-t5-base,allenai/unifiedqa-t5-large --dataset_vals sbic,sensemaking,ecqa --n_gpus 8 --virtual_tokens $1
python scripts/exp.py --exp_root checkpoints --not_dryrun --model_vals allenai/unifiedqa-t5-large --dataset_vals sbic --n_gpus 8 --virtual_tokens $1
# python scripts/exp.py --exp_root checkpoints --not_dryrun --model_vals t5-base,t5-large --dataset_vals esnli --n_gpus 8 --virtual_tokens $1
python scripts/exp.py --exp_root checkpoints --collect_results --virtual_tokens $1
# send notification of completion
echo "Your script for $FULL_JOB_ID has completed running" | mail -s "Script Completion Alert" s2421110@ed.ac.uk
