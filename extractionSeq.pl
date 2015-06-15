use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Date;

my $taxon = $ARGV[0]; # Taxonomy identifier of organism.
my $term; # Term allowing search of a specific protein, metabolic pathway or function.

my $fileList = "list_methabolic_pathways.txt"; # Text file containing a list of metabolic pathways.
open (FILE, "<$fileList") or die "open : $!";

my ($line,@res);

while (defined ($line = <FILE>)){
	chomp($line);
	$line =~ s/ +$//g;
	$line =~ s/\n//g; 
	push (@res, $line);
}

foreach $term (@res){
	
	################################
	## Beginning of the main code ##
	################################
	my $listItem = $term; # Contains each item of my list

	print "---------". $listItem . "------------\n";
	
	my $query = "http://www.uniprot.org/uniprot/?query=organism:$taxon+AND+$term&format=fasta&include=yes";
	my $file = 'uniprot_' . $taxon . '_'. $term . '_FASTA.fasta';

	my $contact = 'david.couvin@cirad.fr'; # Please set your email address here to help us debug in case of problems.
	my $agent = LWP::UserAgent->new(agent => "libwww-perl $contact");
	my $response = $agent->mirror($query, $file);

	if ($response->is_success) {
	  my $results = $response->header('X-Total-Results');
	  my $release = $response->header('X-UniProt-Release');
	  my $date = sprintf("%4d-%02d-%02d", HTTP::Date::parse_date($response->header('Last-Modified')));
	  print "Downloaded $results entries of UniProt release $release ($date) to file $file\n";
	}
	elsif ($response->code == HTTP::Status::RC_NOT_MODIFIED) {
	  print "Data for taxon $taxon is up-to-date.\n";
	}
	else {
	  die 'Failed, got ' . $response->status_line .
		' for ' . $response->request->uri . "\n";
	}

	print "\n";
	print "\n";
	print "Script status: ";
	print $response->status_line . "\n";
	
}
