
# Set your source and destination directories relative to the current directory
source_dir="./checkpoints_sparsefit/"
destination_dir="./esnli_sparsefit_generations/"

# Seeds list
seeds_fewshot=(7004 3639 6290 9428 7056 4864 4273 7632 2689 8219 4523 2175 7356 8975 51 4199 4182 1331 2796 6341 7009 1111 1967 1319 741 7740 1335 9933 6339 3112 1349 8483 2348 834 6895 4823 2913 9962 178 2147 8160 1936 9991 6924 6595 5358 2638 6227 8384 2769 4512 2051 4779 2498 176 9599 1181 5320 588 4791)

# Create destination directory if it doesn't exist
mkdir -p "$destination_dir"

# Iterate through source directories and copy files
for folder_path in "$source_dir"ecqa-*; do
    if [ -d "$folder_path" ]; then
        seed=$(basename "$folder_path" | awk -F'-' '{print $2}')
        if [[ " ${seeds_fewshot[@]} " =~ " $seed " ]]; then
            file_path=$(find "$folder_path" -name 'validation_posthoc_analysis.txt')
            if [ -f "$file_path" ]; then
                cp "$file_path" "$destination_dir${seed}_validation_posthoc.txt"
            fi
        fi
    fi
done

# Set your source and destination directories relative to the current directory
source_dir="./checkpoints_sparsefit/"
destination_dir="./esnli_sparsefit_generations/"

# Seeds list
seeds_fewshot=(7004 3639 6290 9428 7056 4864 4273 7632 2689 8219 4523 2175 7356 8975 51 4199 4182 1331 2796 6341 7009 1111 1967 1319 741 7740 1335 9933 6339 3112 1349 8483 2348 834 6895 4823 2913 9962 178 2147 8160 1936 9991 6924 6595 5358 2638 6227 8384 2769 4512 2051 4779 2498 176 9599 1181 5320 588 4791)

# Create destination directory if it doesn't exist
mkdir -p "$destination_dir"

# Iterate through source directories and copy files
for folder_path in "$source_dir"esnli-*; do
    if [ -d "$folder_path" ]; then
        seed=$(basename "$folder_path" | awk -F'-' '{print $2}')
        if [[ " ${seeds_fewshot[@]} " =~ " $seed " ]]; then
            file_path=$(find "$folder_path" -name 'validation_posthoc_analysis.txt')
            if [ -f "$file_path" ]; then
                cp "$file_path" "$destination_dir${seed}_validation_posthoc.txt"
            fi
        fi
    fi
done
