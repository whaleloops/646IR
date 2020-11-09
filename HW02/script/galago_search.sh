#!/bin/bash
#
# sbatch galago_search.sh
#
#SBATCH --job-name=galago_search
#SBATCH --output=./galago_search.txt
#SBATCH -e ./galago_search.err
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=15
#SBATCH --mem-per-cpu=5G

# cd /mnt/nfs/scratch1/zhiqihuang/yangzhic/HW02

module load python/3.7.3
module load galago/3.18

echo "Started"
timedatectl
sleep 1

cd ../
python gen_query.py
# galago batch-search --verbose=true --index=./index/ --defaultTextPart=postings.krovetz --operatorWrap=combine --requested=10 --scorer=dirichlet --mu=1000 --query="international organized crime)"

echo "----Task 1"
echo " mu=1000"
galago batch-search --index=./index/ --defaultTextPart=postings.krovetz --operatorWrap=combine --scorer=dirichlet --requested=1000 --mu=1000 ./galago_search.json  > search_output.txt
/mnt/nfs/scratch1/zhiqihuang/yangzhic/trec_eval-9.0.7/trec_eval -m map -m recip_rank -m P.10 -m ndcg_cut.5 ./data/robust04.qrels search_output.txt

echo " lambda=0.5"
galago batch-search --index=./index/ --defaultTextPart=postings.krovetz --operatorWrap=combine --scorer=jm --requested=1000 --lambda=0.5 ./galago_search.json  > search_output.txt
/mnt/nfs/scratch1/zhiqihuang/yangzhic/trec_eval-9.0.7/trec_eval -m map -m recip_rank -m P.10 -m ndcg_cut.5 ./data/robust04.qrels search_output.txt

echo " wo"
galago batch-search --index=./index/ --defaultTextPart=postings.krovetz --operatorWrap=combine --scorer=dirichlet --requested=1000 --mu=0 ./galago_search.json  > search_output.txt
/mnt/nfs/scratch1/zhiqihuang/yangzhic/trec_eval-9.0.7/trec_eval -m map -m recip_rank -m P.10 -m ndcg_cut.5 ./data/robust04.qrels search_output.txt


sleep 1
echo "----Task 2"
echo " 1)"
galago batch-search --index=./index/ --defaultTextPart=postings.krovetz \
    --operatorWrap=rm --scorer=dirichlet \
    --requested=1000 --mu=1000  \
    --relevanceModel=org.lemurproject.galago.core.retrieval.prf.RelevanceModel1 \
    --fbDocs=20 \
    --fbTerm=100 \
    ./galago_search.json > search_output21.txt
/mnt/nfs/scratch1/zhiqihuang/yangzhic/trec_eval-9.0.7/trec_eval -m map -m recip_rank -m P.10 \
    ./data/robust04.qrels search_output21.txt

echo " 2)"
galago batch-search --index=./index/ --defaultTextPart=postings.krovetz \
    --operatorWrap=rm --scorer=dirichlet \
    --requested=1000 --mu=1000  \
    --relevanceModel=org.lemurproject.galago.core.retrieval.prf.RelevanceModel3 \
    --fbDocs=20 \
    --fbTerm=100 \
    --fbOrigWeight=0.25 \
    ./galago_search.json > search_output22.txt
/mnt/nfs/scratch1/zhiqihuang/yangzhic/trec_eval-9.0.7/trec_eval -m map -m recip_rank -m P.10 \
    ./data/robust04.qrels search_output22.txt

echo " 3)"
galago batch-search --index=./index/ --defaultTextPart=postings.krovetz \
    --operatorWrap=rm --scorer=dirichlet \
    --requested=1000 --mu=1000  \
    --relevanceModel=org.lemurproject.galago.core.retrieval.prf.RelevanceModel3 \
    --fbDocs=5 \
    --fbTerm=10 \
    --fbOrigWeight=0.25 \
    ./galago_search.json > search_output23.txt
/mnt/nfs/scratch1/zhiqihuang/yangzhic/trec_eval-9.0.7/trec_eval -m map -m recip_rank -m P.10 \
    ./data/robust04.qrels search_output23.txt

echo " 4)"
galago batch-search --index=./index/ --defaultTextPart=postings.krovetz \
    --operatorWrap=rm --scorer=dirichlet \
    --requested=1000 --mu=1000  \
    --relevanceModel=org.lemurproject.galago.core.retrieval.prf.RelevanceModel3 \
    --fbDocs=20 \
    --fbTerm=100 \
    --fbOrigWeight=0.75 \
    ./galago_search.json > search_output24.txt
/mnt/nfs/scratch1/zhiqihuang/yangzhic/trec_eval-9.0.7/trec_eval -m map -m recip_rank -m P.10 \
    ./data/robust04.qrels search_output24.txt

echo "Ended"
timedatectl
