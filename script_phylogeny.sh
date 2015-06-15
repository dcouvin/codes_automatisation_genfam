#!/bin/bash
# 
#Script following the script allowing to automatize functionalities of GenFam
#Given an argument ($1) corresponding to a FASTA file
#
#This script allows to make phylogeny using PhyML and RAPGreen
#

#variables
galaxydevtoolsrepository=''   #Repository of galaxy dev tools        

file=$1                                           #input argument/file

finalfile='final_file.txt'                        #final file containing the trees

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


echo Welcome to the Script
echo Reading of $file

#PhyML
qsub -b y -q web.q ".$galaxydevtoolsrepository/evolution/phyml.sh $file $file$outputtree $outputstats -d aa -m LG -v 0.0 -s NNI -c 4 -a e -b -4 --quiet"
 
#South Green Visualization
#perl data_destination/southgreen_viz.pl $input ${viz.fields.value} $output

echo Script Finished

exit 0
