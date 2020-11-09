#!/bin/bash
#
# sbatch galago_indexing.sh
#
#SBATCH --job-name=galago_indexing
#SBATCH --output=./galago_indexing.txt
#SBATCH -e ./galago_indexing.err
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=15
#SBATCH --mem-per-cpu=5G

module load python/3.7.3
module load galago/3.18

echo "Started"
timedatectl
sleep 1

cd ../
galago build --inputPath=./data/docs.gz --indexPath=./index/ --tokenizer/fields+text --filetype=trectext 

# Index a trec corpus:
# 	galago build --inputPath=trecText.gz --indexPath=./index/ --filetype=trectext
# Run a galago search interface:
# 	galago search --port=8080 --index=./index/
# Run queries with the Query Likelihood model in a json file:
# 	galago batch-search --index=./index/ example_query.json --requested=1000

galago dump-name-length --index=./index/ > dump_name_length.txt
# galago dump-term-stats-ext --indexParts=./index/postings.krovetz --minTF=1000 > dump_term_stats.txt
galago dump-term-stats ./index/postings.krovetz > dump_term_stats.txt
python task1.py

galago batch-search --index=./index/ --defaultTextPart=postings.krovetz --requested=1000 ./galago_search_wo.json  > search_output.txt
/mnt/nfs/scratch1/zhiqihuang/yangzhic/trec_eval-9.0.7/trec_eval -m map -m recip_rank -m P.10 -m ndcg_cut.5 ./data/qrels.txt search_output.txt



echo "Ended"
timedatectl

