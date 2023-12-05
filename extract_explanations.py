import os
import pandas as pd

# Directory where your files are stored
directory = 'sbic_generations'

data = []

for filename in os.listdir(directory):
    if filename.endswith("_validation_posthoc.txt"):
        with open(os.path.join(directory, filename), 'r', encoding='utf-8') as file:
            lines = file.readlines()
            seed = int(filename.split('_')[0])
            # Split the text into groups based on empty lines
            groups = []
            group = []
            for line in lines:
                line = line.strip()
                if line == "":
                    groups.append(group)
                    group = []
                else:
                    group.append(line)
            if group:
                groups.append(group)
            # print(groups)
            # Process each group
            for group in groups:
                
                predicted_label = group[0].split(' | ')[0].split(': ')[1].strip()
                print(predicted_label)
                input_text = group[1].strip()
                considered_correct = group[-1].split(': ')[1].strip()
                print(considered_correct)

                if considered_correct == 'True':
                    if len(group[0].split(' | ')) > 1:
                        predicted_explanation = group[0].split(' | ')[1]
                    else:
                        predicted_explanation = ''
                    data.append({'seed': seed, 'input': input_text, 'predicted_label': predicted_label, 'predicted_explanation': predicted_explanation})

# Creating DataFrame
df = pd.DataFrame(data)
# Save as CSV
df.to_csv('sbic_output_dataframe.csv', index=False)
# ['Predicted: entailment | football players tackle members of the opposing team.', 'A football player tackles an member of the opposing team. People playing football.', 'Correct: entailment | a football player is playing football [SEP] A football player is a person and tackling is part of playing the game. [SEP] One must be playing football to be a football player.', 'Considered Correct: True']