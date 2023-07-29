#!/bin/sh
#SBATCH --partition=PGR-Standard
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:8
#SBATCH --mem=128000  # memory in Mb
#SBATCH --time=0-100:00:00
#SBATCH --array=3-5


# Get the current array index
CURRENT_INDEX=$SLURM_ARRAY_TASK_ID
FULL_JOB_ID="${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}"

# Set the default parameter values
n_current_token=$((CURRENT_INDEX * 10))



export CUDA_HOME=/opt/cuda-9.0.176.1/

export CUDNN_HOME=/opt/cuDNN-7.0/

export STUDENT_ID=$(whoami)

export LD_LIBRARY_PATH=${CUDNN_HOME}/lib64:${CUDA_HOME}/lib64:$LD_LIBRARY_PATH

export LIBRARY_PATH=${CUDNN_HOME}/lib64:$LIBRARY_PATH

export CPATH=${CUDNN_HOME}/include:$CPATH

export PATH=${CUDA_HOME}/bin:${PATH}

export PYTHON_PATH=$PATH


# Activate the relevant virtual environment:

source /home/${STUDENT_ID}/miniconda3/bin/activate feb

# conda activate feb
echo "Your script for ${FULL_JOB_ID}th job has started running" | mail -s "Script Starting Alert" s2421110@ed.ac.uk
python scripts/exp.py --exp_root checkpoints --not_dryrun --model_vals allenai/unifiedqa-t5-base,allenai/unifiedqa-t5-large --dataset_vals sbic,sensemaking,ecqa --n_gpus 8 --virtual_tokens $n_current_token > unifiedqa_vt_${n_current_token}.txt 2>&1
python scripts/exp.py --exp_root checkpoints --not_dryrun --model_vals t5-base,t5-large --dataset_vals esnli --n_gpus 8 --virtual_tokens $n_current_token > t5_vt_${n_current_token}.txt 2>&1
python scripts/exp.py --exp_root checkpoints --collect_results --virtual_tokens $n_current_token > out_vt_${n_current_token}.txt 2>&1
# send notification of completion
echo "Your script for ${FULL_JOB_ID}th job has completed running" | mail -s "Script Completion Alert" s2421110@ed.ac.uk