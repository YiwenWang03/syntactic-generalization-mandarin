## Project Name
Syntactic Generalization Assessment in a Mandarin Setting


## Project Description
As more and more neural language models coming up and showing surprising results on benchmarks such as GLUE, we would like to pause and evaluate what models perform well (or human-like) in syntactic tests (e.g. Subject-Verb Agreement). This project aims to answer this question by comparing state-of-the-art neural network models such as the Transformer family, and also RNNG that learns syntactic information explicitly. Performing well in syntactic tests is important, since it shows if the language models are optimizing their training towards more human-like language, which is crucial in a variety of NLP tasks: next word prediction, question and answering, machine translation and etc. We also saw that a small RNNG model could have a competitive performance with an RNN model that trains on a huge corpus in some language tests(Futrell et al. 2019, NAACL). Therefore, paying more attention to the syntactic knowledge may open a new direction for better NLP models than training on larger and larger datasets.
 
Previous work has been done in an English setting. In this project, we will explore a Mandarin setting. And more importantly, by comparing some common syntactic phenomena, we wish to answer the question whether transfer learning is available in NLP models across languages in terms of syntactic knowledge a general architecture robustly induces humanlike language-specific generalization across languages of different structural statistics, which may shed light on a better machine translation system.
 
Specifically, we will focus on RNN, LSTM, BERT Chinese and RNNG Chinese as the main model architectures. We will build test suites targeting syntactic phenomena that we are interested in. And we will evaluate if data size and model structure affect the process of syntactic learning, and if so, what might be the best combination of data size and model architecture in learning syntactic knowledge.


## Authors
Yiwen Wang, Peng Qian, Jennifer Hu, Roger Levy
