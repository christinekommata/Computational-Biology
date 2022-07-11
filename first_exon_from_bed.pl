#!/usr/bin/perl

use warnings;
use strict;

#anoigoume to arxeio tou eclass
open(BEDFILE,"<","human_exons_prCoding_exercise_set.bed") or die "$!\n";

#edw exoume ta dyo output arxeia 

#grammes opoy einai ta prwta exonia
open(OUTBED,">","first_exons_coordinate.bed") or die "$!\n";

#duo sthles gia to ensembl trancript id kai gia to akrives mhkos tou exoniou
open(OUTTXT,">","exonic_length_per_transcript.txt") or die "$!\n";

#edw ftiaxnouyme ta hash pou xreiazomaste 

my %genes;
my %chrom;
my %exStart;
my %exEnd;
my %score;
my %strand;

my $forward = "+";
my $comp = "-";

#gia kathe grammh sto bedfile

while (my $bedline = <BEDFILE>) {
	# Remove trailing \n (or \r\n for Windows) at the end of the line
	chomp $bedline;
	
	# Split the line in tabs (\t) and store the values in an array
	my @columns = split("\t", $bedline);
	
	my $chrom = $columns[0];
	my $exStart = $columns[1];
	my $exEnd = $columns[2];
	
	# Split the 4th column of the file 
	my @ensembl_ids = split("@", $columns[3]);
	
	#Remember the 4th column looks like this: geneid@transcriptid
	
	my $gene_id = $ensembl_ids[0];
	
	my $transcript_id = $ensembl_ids[1];
	
	my $score = $columns[4];
	my $strand = $columns[5];
	
	
	push @{$genes{$gene_id}}, $transcript_id;
	
	
	push @{$chrom{$gene_id}}, $chrom;
	push @{$exStart{$gene_id}}, $exonStart;
	push @{$exEnd{$gene_id}}, $exonEnd;
    push @{$score{$gene_id}}, $score;
	
	# Also, store the strand for that 'gene_id' in the 'strand' hash
	push @{$strand{$gene_id}}, $strand;
	
}

#printaroume oles tis sthles pou exoume

foreach my $gene (keys %genes)
{ 
		my $current_strand = shift @{$strand{$gene}}; 
		my $resultforward = $current_strand eq $forward;
		my $resultcomplement = $current_strand eq $comp;
		
		
		if ($resultforward == 1) #is equal with +, so we have forward strand
			{
				my $transcript1 = shift @{$genes{$gene}};
				my $shifted_chrom = shift @{$chrom{$gene}};
				my $shifted_exStart = shift @{$exStart{$gene}};
				my $shifted_exEnd = shift @{$exEnd{$gene}};
				my $shifted_score = shift @{$score{$gene}};
				print OUTBED "$shifted_chrom\t$shifted_exonStart\t$shifted_exonEnd\t$gene","@","$transcript1\t$shifted_score\t$current_strand\n";
				
			} 
		elsif ($resultcomplement == 1) #is equal with -, so we have complement strand
			{   
			    
			    unshift @{$strand{$gene}}, $current_strand;
				
				my $transcript2 = shift @{$genes{$gene}};
				my $popped_chrom = pop @{$chrom{$gene}};
				my $popped_exStart = pop @{$exStart{$gene}};
				my $popped_exEnd = pop @{$exEnd{$gene}};
				my $popped_score = pop @{$score{$gene}};
				my $popped_strand = pop @{$strand{$gene}};
			    print OUTBED "$popped_chrom\t$popped_exonStart\t$popped_exonEnd\t$gene","@","$transcript2\t$popped_score\t$popped_strand\n";
				
			}	
		else{
		     print "Error\n";
		}
}

close BEDFILE;
close OUTBED;

