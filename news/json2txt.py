#!/usr/bin/env python
# coding: utf-8


import json
import random
from random import sample
import benepar
import spacy
import argparse
import re

random.seed(123)
print("Libraries Loaded!")

parser = argparse.ArgumentParser(description='PyTorch RNN/LSTM Language Model')
# Model parameters
parser.add_argument('--data_path', type=str, default='./new2016zh/',
                    help='path to the data file')
parser.add_argument('--output_path', type=str, default='./',
                    help='path to the output file')
parser.add_argument('--num_data', type=int, default=10,
                    help='num data entries will be randomly selected')

args = parser.parse_args()


try:
    nlp = spacy.load('zh_core_web_md')
except:
    print('Language model not downloaded, please refer to https://github.com/nikitakit/self-attentive-parser#available-models')

try:
    if spacy.__version__.startswith('2'):
            nlp.add_pipe(benepar.BeneparComponent("benepar_zh2"))
    else:
            nlp.add_pipe("benepar", config={"model": "benepar_zh2"})
except:
    # load the necessary model for parsing
    benepar.download('benepar_zh2')

with open(args.data_path + 'news2016zh_valid.json') as json_file:
    data = json.loads("[" + 
        json_file.read().replace("}\n{", "},\n{") + "]")


print('Models Loaded!')
print(str(args.num_data) + ' data entries')

sample_data = sample(data,int(args.num_data))

txt = []
# split by 。 add \n to the each valid sentence
for i in sample_data:
    temp = i['content'].split('。')
    for sent in temp:
        if sent != temp[-1]:
            txt.append(sent.strip()+'。\n') # remove trailing space
        elif sent != '':
            txt.append(sent.strip()+'\n')

# print(txt)

sample_data = []
# split by ？ only add ? for valid sentences (not the last segment)
for i in txt:
    temp = i.split('？')
    if len(temp) > 1:
        for sent in temp:
            if sent != temp[-1]:
                sample_data.append(sent.strip()+'？\n') # remove trailing space
            elif sent != '\n':
                sample_data.append(sent)
    else:
        sample_data.append(temp[0])

# print(sample_data)
txt = []
# split by ! only add ! for valid sentences (not the last segment)
for i in sample_data:
    temp = i.split('！')
    if len(temp) > 1:
        for sent in temp:
            if sent != temp[-1]:
                txt.append(sent.strip()+'！\n') # remove trailing space
            elif sent != '\n':
                txt.append(sent)
    else:
        txt.append(temp[0])

# save the random sample data
file = open(args.output_path + "data.txt","w")
file.writelines(txt)
file.close()

print('--- Start Parsing ---')

# save terms txt file
file1 = open(args.output_path + "news-terms.txt","w")

# save tree txt file
file2 = open(args.output_path + "news.txt","w")


# iterate the text and only save the completed sentences
for text in txt:
    try:
        doc = nlp(text.replace('\n', ''))
    except:
        print('Runtime Error for '+text)
        continue
    if len(list(doc.sents)) == 1 and bool(re.search('IP',str(list(doc.sents)[0]._.labels))):
        file1.writelines(' '.join([i.text for i in doc]) + '\n')
        file2.writelines(list(doc.sents)[0]._.parse_string + '\n')


file1.close()
file2.close()
print('Tasks Completed!')




