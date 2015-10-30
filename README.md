----------

Haruo Suzuki (haruo[at]g-language[dot]org)  
Last Update: 2015-10-30  

----------

# Living Tree Project (LTP)
Project started 2015-10-09.

## Project directories

	ltp/
	  README.md: project documentation 
	  bin/: scripts
	  data/: sequence data
	  results/: results of analyses

## Data
Data was downloaded on 2015-10-09 into `data/`, using:

	wget -o wget.log http://www.arb-silva.de/fileadmin/silva_databases/living_tree/LTP_release_123/LTPs123_SSU.compressed.fasta.tar.gz
	tar xvzf LTPs123_SSU.compressed.fasta.tar.gz 

----------

## Steps

### Inspecting Data

	cd data/
	grep ">" LTPs123_SSU.compressed.fasta | wc -l # 11939

以下の通り、LTP（*LTPs123_SSU.compressed.fasta*）では、SILVA（*SILVA_123_SSURef_Nr99_tax_silva_trunc.fasta*）と比較して、分類群情報（taxonomic ranks: domain;phylum;class;order;family;genus;species）が少ない。

	$grep AB190217 LTPs123_SSU.compressed.fasta
	>AB190217	1	1306	1306bp	rna	Bacillus anthracis	Bacillaceae

	$grep AB190217 SILVA_123_SSURef_Nr99_tax_silva_trunc.fasta
	>AB190217.1.1306 Bacteria;Firmicutes;Bacilli;Bacillales;Bacillaceae;Bacillus;Bacillus anthracis

### [Building a BLAST database](http://www.ncbi.nlm.nih.gov/books/NBK279688/)

	cd data/
	DB=LTPs123_SSU.compressed.fasta
	makeblastdb -in $DB -dbtype nucl -hash_index -parse_seqids > makeblastdb.$DB.log 2>&1

#### Error

	$less makeblastdb.LTPs123_SSU.compressed.fasta.log

	Error: (803.7) [makeblastdb] Blast-def-line-set.E.title
	Bad char [0x9] in string at byte 17
	defectiva       Aerococcaceae
	Error: (803.7) [makeblastdb] Blast-def-line-set.E.seqid.E.local.str
	Bad char [0x9] in string at byte 49
	D50541  1       1411    1411bp  rna     Abiotrophia

[How can I format RDP database to be used in a BLAST search? - SEQanswers](http://seqanswers.com/forums/showthread.php?t=44700) | Problem is likely a tab character

FASTAファイル（*LTPs123_SSU.compressed.fasta*）のヘッダのタブ区切りが問題か。

> I reported the Error to <contact@arb-silva.de>, and got a response  
From: Raul Muñoz <raul@imedea.uib-csic.es>  
Subject: Re: tab and taxonomic ranks in FASTA file header  

One can substituting tabs by spaces in the fasta file, using:  

	perl -pe 's/\t/ /g' LTPs123_SSU.compressed.fasta > tmp.fasta

OR

	cat LTPs123_SSU.compressed.fasta | tr '\11' ' ' > tmp.fasta

Then, Building a BLAST database, using:
	
	makeblastdb -in tmp.fasta -dbtype nucl -hash_index -parse_seqids

printed the following Error messages:

	BLAST Database creation error: Error: Duplicate seq_ids are found: 
	LCL|CP001336

	$grep -n "CP001336" LTPs123_SSU.compressed.fasta
	59310:>CP001336	3389423	3391083	1661bp	rna	Desulfitobacterium hafniense	Peptococcaceae
	59332:>CP001336	3873538	3875208	1671bp	rna	Desulfitobacterium hafniense	Peptococcaceae

### [Extracting data from BLAST databases with blastdbcmd](http://www.ncbi.nlm.nih.gov/books/NBK279689/)

	cd data/
	NAME=Bacillus
	DB=SILVA_123_SSURef_Nr99_tax_silva_trunc.fasta
	blastdbcmd -db $DB -entry all -outfmt "%i %t" | grep "$NAME" | \
 	awk '{print $1}' | blastdbcmd -db $DB -entry_batch - > $NAME.fasta

#### Error

	BLAST Database error: No alias or index file found for nucleotide database [SILVA_123_SSURef_Nr99_tax_silva_trunc.fasta] in search path [/Users/haruo/myGitHub/ltp/data::]
	BLAST Database error: No alias or index file found for nucleotide database [SILVA_123_SSURef_Nr99_tax_silva_trunc.fasta] in search path [/Users/haruo/myGitHub/ltp/data::]

----------

## References
- [Living Tree](http://www.arb-silva.de/projects/living-tree/)
- [Nucleic Acids Res. 2014 Jan;42(Database issue):D643-8. The SILVA and "All-species Living Tree Project (LTP)" taxonomic frameworks.](http://www.ncbi.nlm.nih.gov/pubmed/24293649)
- ['The All-Species Living Tree' Project - Wikipedia, the free encyclopedia](https://en.wikipedia.org/wiki/%27The_All-Species_Living_Tree%27_Project)

----------


