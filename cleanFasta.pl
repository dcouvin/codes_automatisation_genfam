#!/usr/bin/perl
use strict;
use warnings;



my $fastaFile = $ARGV[0]; # Fasta File in which we are searching for mistakes (organisms being not MAIZE or ORYSJ).
my $sequences=0; # To count the number of sequences.
my $resultFile = "results.txt"; #File resulting from the reading of the sequences file

my $newFasta = "newFasta.fasta"; #New FASTA file containing the good sequences (MAIZE|ORYSJ) or another

my $searchedspecies = $ARGV[1]; # searched species, entered by the user

my $fileAccessionNumber = "accessionNumbers.txt"; #File which will contain all my accession numbers

open (FILE, "<$fastaFile") or die "open : $!";

open (FICHIER, ">$resultFile") || die ("You cannot create file \"$resultFile\"");

open (FILEFASTA, ">$newFasta") || die ("You cannot create file \"$newFasta\"");

my ($line,@res);
my $countLine=0; #Count all lines in the file.
my $wrongSeqs=0; #Give the number of incorrect sequences

while (defined ($line = <FILE>)){
	chomp($line);
	$countLine++;
	
	
	if($line =~ m/>/){
		#Instruction allowing to count the sequences in our FASTA file
		$sequences++;
		my $newLine=$line;
		if($newLine !~ m/$searchedspecies/){
		#Instruction allowing to target sequences that are not MAIZE nor ORYSJ
		$wrongSeqs++;
		print FICHIER "Line------------------------>$countLine \n";
		#print "Line------------------------>$countLine \n";
		}
		
	}
	
	
	
	
}
#Display the total number of sequences
print "\n\n\n\n";
print "Number of wrong sequences : ()()()()()()()()()>$wrongSeqs \n";
print FICHIER "Number of wrong sequences : ()()()()()()()()()>$wrongSeqs \n";
print "Total number of sequences : **********>$sequences \n";
print FICHIER "Total number of sequences : **********>$sequences \n";

#Close file FICHIER (results.txt)
close(FICHIER);
close(FILE);
close(FILEFASTA);


open (FILE, "<$fastaFile") or die "open : $!";
open (FILEFASTA, ">$newFasta") || die ("You cannot create file \"$newFasta\"");

#Write only the good accession numbers within a text file
open (FILEACCESS,">$fileAccessionNumber") || die ("You cannot create file \"$fileAccessionNumber\"");

my $line2="";
my $var ="";
while (defined ($line2 = <FILE>)){
	chomp($line2);
	my $newLine2 = $line2;
	if($line2 =~ m/>/){
		
		if($line2 =~ m/>.*$searchedspecies/){
			#Instruction allowing to print only MAIZE or ORYSJ sequences
			print FILEFASTA "$line2 \n";
			#print FILEFASTA $_;
			my @lineValues = split('\|', $line2);
			print FILEACCESS "$lineValues[1]\n";
			print "$lineValues[1]\n";
		}
		#print FILEFASTA $line2 unless ($line2 !~ m/>/);
	
	}
}

close(FILE);
close(FILEFASTA);
close(FILEACCESS);

