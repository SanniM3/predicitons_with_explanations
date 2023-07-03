#!/bin/sh
#SBATCH --partition=ILCC_GPU
#SBATCH --gres=gpu:4
#SBATCH --mem=64000  # memory in Mb
#SBATCH --time=0-100:00:00
#SBATCH --array=1-11


# Define the parameter values
ranks=(4 8 16 32)
modules=("q" "v")

# Get the current array index
CURRENT_INDEX=$SLURM_ARRAY_TASK_ID
FULL_JOB_ID="${SLURM_JOB_ID}_${SLURM_ARRAY_TASK_ID}"

# Set the default parameter values
current_rank=""
current_module=""

# Assign the parameter values based on the array index
if [ $CURRENT_INDEX -eq 1 ]; then
    current_rank=${ranks[0]}
    current_module="[${modules[0]}]"
elif [ $CURRENT_INDEX -eq 2 ]; then
    current_rank=${ranks[0]}
    current_module="[${modules[1]}]"
elif [ $CURRENT_INDEX -eq 3 ]; then
    current_rank=${ranks[0]}
    current_module="[${modules[0]}, ${modules[1]}]"
elif [ $CURRENT_INDEX -eq 4 ]; then
    current_rank=${ranks[2]}
    current_module="[${modules[0]}]"
elif [ $CURRENT_INDEX -eq 5 ]; then
    current_rank=${ranks[2]}
    current_module="[${modules[1]}]"
elif [ $CURRENT_INDEX -eq 6 ]; then
    current_rank=${ranks[2]}
    current_module="[${modules[0]}, ${modules[1]}]"
elif [ $CURRENT_INDEX -eq 7 ]; then
    current_rank=${ranks[3]}
    current_module="[${modules[0]}]"
elif [ $CURRENT_INDEX -eq 8 ]; then
    current_rank=${ranks[3]}
    current_module="[${modules[1]}]"
elif [ $CURRENT_INDEX -eq 9 ]; then
    current_rank=${ranks[3]}
    current_module="[${modules[0]}, ${modules[1]}]"
elif [ $CURRENT_INDEX -eq 10 ]; then
    current_rank=${ranks[1]}
    current_module="[${modules[0]}]"
elif [ $CURRENT_INDEX -eq 11 ]; then
    current_rank=${ranks[1]}
    current_module="[${modules[1]}]"
fi


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
echo "Your script for ${FULL_JOB_ID}th job has started running" | mail -s "Script Starting Alert" s2421110@ed.ac.uk
python scripts/exp.py --exp_root checkpoints --not_dryrun --model_vals allenai/unifiedqa-t5-base,allenai/unifiedqa-t5-large,allenai/unifiedqa-t5-3b --dataset_vals ecqa,sensemaking,sbic --n_gpus 4 --lora_rank $current_rank --lora_target_modules $current_module
python scripts/exp.py --exp_root checkpoints --not_dryrun --model_vals t5-base,t5-large,t5-3b --dataset_vals esnli --n_gpus 4 --lora_rank $current_rank --lora_target_modules $current_module
python scripts/exp.py --exp_root checkpoints --collect_results
# send notification of completion
echo "Your script for ${FULL_JOB_ID}th job has completed running" | mail -s "Script Completion Alert" s2421110@ed.ac.uk
