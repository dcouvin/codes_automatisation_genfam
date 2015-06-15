#!/usr/bin/perl

#################Prog_Stat_Phylip_file##############################
## Program allowing to get the first line of Phylip file and
## to get statistics on number of lines as well length of sequences 
####################################################################

use strict;

my $firstline;
#my $line;

my $nb=0;

my $directory_phylip = 'results_script_analysis_ucluster/'; #Directory in which phylip file is
my $filename = $ARGV[0]; # Phylip File for which we need statistics 

my $results = 'results_good_phylips.txt'; # Result file containing all the phylips files having a good format

my $stats = 'stats_phylip_stats.txt'; # Stats file containing the informations on phylip files. 

#Writing results in the results file
open (FILERESULT, ">>$results") or die "open : $!";

#Writing results in the results file
open (FILESTAT, ">>$stats") or die "open : $!";

#Opening, Reading and printing of statistics corresponding to the file
open (FILE, "<$filename") or die "open : $!";

#If statistics are good, print OK
$firstline = <FILE> ;
chomp($firstline);
#print $firstline."\n";

my ($nbsequences,$lengthseqs);
my ($title,$extension) = split(/\./, $filename);

($nbsequences,$lengthseqs) = split(/\s/, $firstline);
print "\n";
print "----------------------------".$filename."----------------------------\n";
print "The Number of sequences is: --------> ".$nbsequences."\n";
print "The Lenght of sequences is: --------> ".$lengthseqs."\n";
#print $title.$nb.".".$extension;
print "\n";

if($nbsequences <= 1600 and $lengthseqs > 4 and ($nbsequences*$nbsequences*$lengthseqs<3000000)){
	#print "Nb of sequences <= 100\n";
	print FILERESULT "$filename\n";
}
if($nbsequences > 100){
	#print "Warnings: Nb of sequences > 100\n";
}

#print statistics: first number indicates (as in phylip file) the number of sequences, 
#and the second number indicates the length of sequences
print FILESTAT "$filename => $nbsequences / $lengthseqs\n";
