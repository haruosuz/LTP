----------

Haruo Suzuki (haruo[at]g-language[dot]org)  
Last Update: 2015-12-20  

----------

# Living Tree Project (LTP) project
Project started 2015-10-09.

## Project directories

    ltp/
     README.md: project documentation 
     data/: contains sequence data in FASTA or BLAST database format

## Data
Data was downloaded on 2015-12-20 into `data/`, using:

    wget -b http://www.arb-silva.de/fileadmin/silva_databases/living_tree/LTP_release_123/LTPs123_SSU.compressed.fasta.tar.gz
    tar xvzf LTPs123_SSU.compressed.fasta.tar.gz 

----------

## Steps

### Inspecting Data

`ls -l`でファイルの詳細情報を表示:  

    $ls -lh LTPs123_SSU.compressed.fasta*
    -rw-r--r--  1 haruo  staff    19M Aug 10 17:00 LTPs123_SSU.compressed.fasta
    -rw-r--r--  1 haruo  staff   4.2M Aug 24 18:21 LTPs123_SSU.compressed.fasta.tar.gz

`grep`でFASTA形式ファイルのヘッダ（`>`で始まる行）を表示し、`wc -l`で行数を表示し、配列エントリ数をカウント:  

    grep '^>' LTPs123_SSU.compressed.fasta | wc -l # 11939

配列エントリ数は、11,939件。

以下の通り、LTP（*LTPs123_SSU.compressed.fasta*）では、SILVA（*SILVA_123_SSURef_Nr99_tax_silva_trunc.fasta*）と比較して、分類群情報（taxonomic ranks: domain;phylum;class;order;family;genus;species）が少ない。

    $grep 'AB190217' LTPs123_SSU.compressed.fasta
    >AB190217	1	1306	1306bp	rna	Bacillus anthracis	Bacillaceae

    $grep 'AB190217' SILVA_123_SSURef_Nr99_tax_silva_trunc.fasta
    >AB190217.1.1306 Bacteria;Firmicutes;Bacilli;Bacillales;Bacillaceae;Bacillus;Bacillus anthracis

### [Building a BLAST database](http://www.ncbi.nlm.nih.gov/books/NBK279688/)

    DB=LTPs123_SSU.compressed.fasta
    makeblastdb -in $DB -dbtype nucl -hash_index -parse_seqids > makeblastdb.$DB.log 2>&1

#### Error

    $grep "Error" makeblastdb.LTPs123_SSU.compressed.fasta.log | sort | uniq
    Error: (803.7) [makeblastdb] Blast-def-line-set.E.seqid.E.local.str
    Error: (803.7) [makeblastdb] Blast-def-line-set.E.title

[How can I format RDP database to be used in a BLAST search? - SEQanswers](http://seqanswers.com/forums/showthread.php?t=44700) | Problem is likely a tab character

FASTAファイル（*LTPs123_SSU.compressed.fasta*）のヘッダのタブ区切りが問題。
以下の通り、エラーを報告。タブをスペースに置換したが、重複IDの存在によりエラー。

> I reported the Error to <contact@arb-silva.de>, and got a response  
From: Raul Muñoz <raul@imedea.uib-csic.es>  
Subject: Re: tab and taxonomic ranks in FASTA file header  

One can substituting tabs by spaces in the fasta file, using:  

    perl -pe 's/\t/ /g' LTPs123_SSU.compressed.fasta > tmp.pl.fasta
    # OR
    cat LTPs123_SSU.compressed.fasta | tr '\11' ' ' > tmp.tr.fasta

Then, Building a BLAST database, using:

    makeblastdb -in tmp.fasta -dbtype nucl -hash_index -parse_seqids

printed the following Error messages:

    BLAST Database creation error: Error: Duplicate seq_ids are found: 
    LCL|CP001336

    $grep -n 'CP001336' LTPs123_SSU.compressed.fasta
    59310:>CP001336	3389423	3391083	1661bp	rna	Desulfitobacterium hafniense	Peptococcaceae
    59332:>CP001336	3873538	3875208	1671bp	rna	Desulfitobacterium hafniense	Peptococcaceae



----------

## References
- [Living Tree](http://www.arb-silva.de/projects/living-tree/)
- [Nucleic Acids Res. 2014 Jan;42(Database issue):D643-8. The SILVA and "All-species Living Tree Project (LTP)" taxonomic frameworks.](http://www.ncbi.nlm.nih.gov/pubmed/24293649)
- ['The All-Species Living Tree' Project - Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/%27The_All-Species_Living_Tree%27_Project)

----------


