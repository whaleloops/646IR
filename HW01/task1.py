from collections import defaultdict
import csv

def generate_json_to_search(in_txt_path, ou_json_path):
    with open(ou_json_path, 'w') as wfile:
        wfile.write('{\n')
        wfile.write('\"queries\": [\n')

        with open(in_txt_path, 'r') as rfile:
            lines = rfile.readlines() 
            idx = 1
            for line in lines:
                line = line.strip()
                if line[0:7] == '<title>':
                    text2write = line[7:-8]
                    wfile.write('{ \"number\": \"%d\", \n'%idx)
                    wfile.write('\"text\": \"%s\" },\n'%text2write)
                    idx += 1
        wfile.write(']\n')
        wfile.write('}\n')

def main():
    # patients = defaultdict(lambda: defaultdict(list)) #lambda: "Not Present"
    doc_length = {}
    total_num_words = 0 
    with open('./dump_name_length.txt') as csvfile: 
        readCSV = csv.reader(csvfile, delimiter='\t')
        for row in readCSV:
            intern_id = row[0]
            extern_id = row[1]
            length = int(row[2])
            doc_length[extern_id] = length
            total_num_words +=  length

    print("The number of documents in the corpus {}".format(len(doc_length)))
    print("The average length of documents {}".format(total_num_words/len(doc_length)))

    dictionary = {}
    dict_in_doc = {}
    with open('./dump_term_stats.txt') as csvfile: 
        readCSV = csv.reader(csvfile, delimiter='\t')
        for row in readCSV:
            word = row[0]
            term_frequency = int(row[1])
            document_count = int(row[2])
            dictionary[word] = term_frequency
            dict_in_doc[word] = document_count
    
    print("The number of unique words in the corpus {}".format(len(dict_in_doc)))
    max_len = 0
    max_len_docid = None
    for e_id,length in doc_length.items():
        if length > max_len:
            max_len_docid = e_id
            max_len = length
    print("The document id (in <DOCNO>) of the longest document and the document length is id: {} and {}".format(max_len_docid, max_len))
    print("The number of documents that contain the word “information” {} ".format(dict_in_doc["information"]))


    generate_json_to_search("./data/queries.txt", "./galago_search.json")


if __name__ == "__main__":
    main()
