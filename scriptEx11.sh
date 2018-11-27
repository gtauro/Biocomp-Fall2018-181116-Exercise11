# USAGE: bash scriptEx11.sh
# To be used in conjuction with Biocomp-Fall2018-181116-Exercise11 directory and all accompanying sub-directories and files
# Muscle and HMMer are used to work with .fasta data. They must be installed in ~/local/bin.


# QUESTION 1

touch ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/sporecoat.fasta  # Creates a .fasta file to store the aggregate of sporecoat0*.fasta
touch ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/transporter.fasta  # Creates a .fasta file to store the aggregate of transporter0*.fasta

for i in {1..4}  # Initializes loop that runs through all sporecoat0*.fasta and transporter0*.fasta files in order to store them into single files
do
	cat ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/sporecoat0$i.fasta >> ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/sporecoat.fasta
	echo >> ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/sporecoat.fasta  # Creates new line in between entries
	cat ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/transporter0$i.fasta >> ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/transporter.fasta 
	echo >>  ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/transporter.fasta
done

~/local/bin/muscle3.8.31_i86linux64 -in ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/sporecoat.fasta -out ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/sporecoat.fasta.align  # Uses Muscle to create sporecoat.fasta alignment
~/local/bin/muscle3.8.31_i86linux64 -in ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/transporter.fasta -out ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/transporter.fasta.align  # Uses Muscle to create transporter.fasta alignment

# Required output for script will be located in ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences directory


# QUESTION 2

~/local/bin/hmmbuild ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/transporter.hmm ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/transporter.fasta.align  # Uses hmmbuild to generate an HMM profile for newly aligned transporter.fasta.align file

touch ~/Biocomp-Fall2018-181116-Exercise11/transporterProfile.txt  # Creates transporterProfile.txt file for storage of hmmsearch data

for file in ~/Biocomp-Fall2018-181116-Exercise11/proteomes/*.fasta  # Initializes loop that searches through proteosomes and returns filename and number of hits to profile to transporterProfile.txt
do
	~/local/bin/hmmsearch --tblout resultshmm.txt ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences/transporter.hmm $file  # Stores hmmsearch information in temporary resultshmm.txt
	(echo "FILENAME: "; echo $(basename $file)) >> ~/Biocomp-Fall2018-181116-Exercise11/transporterProfile.txt  # Inserts filename into transporterProfile.txt file
	count=$(cat resultshmm.txt | grep -v "#" | wc -l)  # Generates number of hits found in hmmsearch through a line count of uncommented lines in resultshmm.txt
	(echo "HIT COUNT: "; echo $count; echo) >> ~/Biocomp-Fall2018-181116-Exercise11/transporterProfile.txt  # Inserts number of hits ($count) into transporterProfile.txt file
done

rm resultshmm.txt  # Removes temporary resultshmm.txt file

# Required output for script will be located in ~/Biocomp-Fall2018-181116-Exercise11/gene_sequences directory and generated transporterProfile.txt file

