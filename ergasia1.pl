#!/usr/bin/perl

use warnings;
use strict;

#prwta anoigoume to arxeio yersinia_genome.fasta

open(FASTA,"<", "yersinia_genome.fasta") or die "error: $!\n";
open(FASTA02,">", "yersinia_genome2.fasta") or die "$!\n";

my $line1= "";
my $line = "";
my $seq = "";
my $fasta_header = "";
my $fasta_seq = "";
my $orf_counter = 0;

# Iterate the FASTA file line-by-line
while (my $line = <FASTA>) {
	chomp $line;
	if ($line =~ /^>.+/) {
		$fasta_header = $line;
	} else {	
		$fasta_seq .= $line; # or $fasta_seq = $fasta_seq.$line;
	}
}
print FASTA02 "This is the header: ", $fasta_seq, "\n";


while (my $line= <FASTA>){
	chomp $line; #chop/remove newline char at the end!
	$seq=$seq.$line;	# $seq.=$first_line;
}
print FASTA02 "This is the fasta sequence:", $seq, "\n";

while (my $line =~/^>.+/){
	chomp $line1;
}
	print $line1


#Create reverse complement seq and print to FASTA02

my $rev_comp_seq = reverse($seq);
$rev_comp_seq =~ tr/ATCG/TAGC/;

print FASTA02 "$line\n$rev_comp_seq\n";

#matching the atg in the sequence sthn seq (forward strand)

while ($seq =~ /(ATG)/g) {
	my $start_searching_index = $-[1];
	for (my $pos = $start_searching_index; $pos < length($seq);$pos+=3){
		my $codon = substr($seq,$pos,3);
		if ($codon eq "TAA" | $codon eq "TAG" | $codon eq "TGA") {
			if ($pos != $start_searching_index+3){
				my $ORF_end = $pos +2;
				#print "Found ORF at",$start_searching_index+1, "-",$ORF_end+1, "in forward strand.\n";
				
				$orf_counter += 1;
			}
			last;
		}
	}
}

#twra kanoume search sthn reverse seq

while ($rev_comp_seq =~ /(ATG)/g) {
	my $start_searching_index = $-[1];
	for (my $pos = $start_searching_index; $pos<length($rev_comp_seq);$pos+=3) {
		my $codon = substr($rev_comp_seq, $pos, 3);
		if ($codon eq "TAA" | $codon eq "TAG" | $codon eq "TGA") {
			if ($pos != $start_searching_index+3) {
				my $rev_start = length($rev_comp_seq) - $start_searching_index;
				my $rev_ORF_end = length($rev_comp_seq) - ($pos+2);
				#print "Found ORF at ", $rev_start, "-", $rev_ORF_end, "in reverse strand.\n";
				
				$orf_counter += 1;
			}
			last;
		}
	}
}
print "\nFound".$orf_counter." ORFs in total.\n";
