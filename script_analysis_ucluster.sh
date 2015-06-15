#!/bin/bash
# 
#Script allowing to automatize functionalities of GenFam
#Given an argument ($1) corresponding to a FASTA file
#

#variables
galaxydevtoolsrepository=''   #Repository of galaxy dev tools        

file=$1                                           #input argument/file
tempfile='tempfile.fasta'                         #Temporary file
hmmbuildfile='hmmbuild.txt'                       #HMMBUILD (process following the MAFFT)
resulthmmsearch='result_hmmsearch.txt'            #HMMSEARCH MULTI SPECIES
resulthmmertofasta='result_hmmertofasta.fasta'    #HMMER TO FASTA MULTI
formatfastaheader='format_fasta_header.fasta'     #Format FASTA HEADER

secondmafft='second_mafft.fasta'                  #Second MAFFT
gblocks='gblocks.fasta'				  #GBLOCKS
gblocksstats='gblocks_stats'			  #GBLOCKS STATS
phylip='phylip.txt'                               #PHYLIP Tree

#PhyML
outputtree='output_tree.nhx'	                  #Output Tree PhyML (nhx)
outputstats='output_stats.txt'                    #Output statistics PhyML

#RAP-Green
inputspecies='fasta_tools/viridiplantae.phyloxml' #Species tree used in RAP-Green
outputgenerapgreen='output_gene_rapgreen.txt'      #Output Gene Tree RAP-Green 
output_gene_phyloxml='output_gene_phyloxml.txt'    #Output PhyloXML
output_species='output_species.txt'
output_reconciled='output_reconciled.txt'
output_statsrg='output_statsrg.txt'
gene_threshold='0.95'
species_threshold='10.0'
polymorphism_threshold='0.00'

#File containing all my phylips
phylipfiles='all_phylips.txt'

echo Welcome to the Script

#chmod +x $galaxydevtoolsrepository

echo Reading of $file

#the cp command could also be used with another directory (e.g. results_maize_orysj_id_0.97
cp results_maize_orysj_arath_id_0.97/$file $tempfile

pwd $file

#MAFFT
.$galaxydevtoolsrepository/sequence_comparisons/mafft.sh $tempfile > mafft_$file
#HMMBUILD
.$galaxydevtoolsrepository/sequence_comparisons/hmmbuild.sh $hmmbuildfile mafft_$file

#other bricks (GenFam)
# RICE database:  /usr/local/bioinfo/galaxy/genfam/ORYSJ-MSU7-polypeptide-genfam.faa
python2.6 .$galaxydevtoolsrepository/genfam/multi_hmmsearch.py /home/couvin/jobs/Clean_Fasta_Uclust_Script/$hmmbuildfile /home/couvin/jobs/Clean_Fasta_Uclust_Script/$resulthmmsearch 'base_list' /usr/local/bioinfo/galaxy/genfam/MAIZE-MGDB5b60-polypeptide-genfam.faa /usr/local/bioinfo/galaxy/genfam/SORBI-JGI1.4-polypeptide-genfam.faa

python2.6 .$galaxydevtoolsrepository/genfam/multi_hmmertofasta.py /home/couvin/jobs/Clean_Fasta_Uclust_Script/$resulthmmsearch evalue 0.0000005 /home/couvin/jobs/Clean_Fasta_Uclust_Script/$resulthmmertofasta /usr/local/bioinfo/galaxy/genfam/MAIZE-MGDB5b60-polypeptide-genfam.faa /usr/local/bioinfo/galaxy/genfam/SORBI-JGI1.4-polypeptide-genfam.faa

python2.6 .$galaxydevtoolsrepository/genfam/format_fasta.py "NONE" $resulthmmertofasta $formatfastaheader

#re-Do MAFFT
.$galaxydevtoolsrepository/sequence_comparisons/mafft.sh $formatfastaheader > $secondmafft
#Gblocks
.$galaxydevtoolsrepository/sequence_comparisons/gblocks.sh $secondmafft $gblocks $gblocksstats 52 85 -t=p -b3=8 -b4=3 -b5=h

#FASTA to Phylip
.$galaxydevtoolsrepository/fasta_tools/fasta_to_phylip.sh $gblocks $phylip ''

#Process to delete unused files

rm -f mafft_$file
#rm -f $hmmbuildfile
#rm -f $resulthmmsearch
#rm -f $resulthmmertofasta
#rm -f $formatfastaheader
#rm -f $secondmafft
#rm -f $gblocks
#rm -f result_hmmsearch.txt.*
#rm -f $formatfastaheader.tree
#rm -f $tempfile
#rm -f $tempfile.tree


mv $gblocksstats results_script_analysis_ucluster/gblocks_stats


#PhyML
#qsub -b y -q web.q ".$galaxydevtoolsrepository/evolution/phyml.sh $phylip $outputtree $outputstats -d aa -m LG -v 0.0 -s NNI -c 4 -a e -b -4 --quiet"

#RAP-Green
#.$galaxydevtoolsrepository/evolution/rapgreen.sh -g $outputtree -s $inputspecies -og $outputgenerapgreen -phyloxml $output_gene_phyloxml -os $output_species -or $output_reconciled -stats $output_statsrg -gt $gene_threshold -st $species_threshold -pt $polymorphism_threshold -outparalogous


mv $phylip results_script_analysis_ucluster/$file$phylip

echo $file$phylip >> results_script_analysis_ucluster/$phylipfiles

#mv $outputtree results_script_analysis_ucluster/$file$outputtree
#mv $outputgenerapgreen results_script_analysis_ucluster/$file$outputgenerapgreen
#mv $output_gene_phyloxml results_script_analysis_ucluster/$file$output_gene_phyloxml
#mv $output_species results_script_analysis_ucluster/$file$output_species
#mv $output_reconciled results_script_analysis_ucluster/$file$output_reconciled
#mv $output_statsrg results_script_analysis_ucluster/$file$output_statsrg
 
#South Green Visualization
#perl data_destination/southgreen_viz.pl $input ${viz.fields.value} $output

echo Script Finished

exit 0
