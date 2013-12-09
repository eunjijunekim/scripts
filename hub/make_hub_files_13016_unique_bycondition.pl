$sampleinfo_file = $ARGV[0]; #sampleinfo file
$datasetName = $ARGV[1]; # e.g 9_paschos_rnaseq2
$hubName = $ARGV[2]; # e.g 13016
$studyTitle = $ARGV[3]; # e.g "Bmal1KO_TC liver RNA-seq - by condition"

$hubfile = $hubName . "_byCondition.txt";
open(OUTFILE, ">$hubfile");
print OUTFILE "hub s3.amazonaws.com/itmat.data/fgdb/datasets/$datasetName/cov/$hubName/ \n";
print OUTFILE "shortLabel $hubName byCondition \n";
print OUTFILE "longLabel $studyTitle \n";
print OUTFILE "genomesFile " . $hubName . "_byCondition_genome.txt \n";
print OUTFILE "email eunji.june.kim\@gmail.com";
close(OUTFILE);

$genome_file = $hubName . "_byCondition_genome.txt";
open(OUTFILE, ">$genome_file");
print OUTFILE "genome mm9 \n";
print OUTFILE "trackDb mm9/". $hubName ."_byCondition_trackDb.txt";
close(OUTFILE);

$track_file = "mm9/" . $hubName . "_byCondition_trackDb.txt";
open(OUTFILE, ">$track_file");

open(INFILE, $sampleinfo_file); #sample_info file
while ($line = <INFILE>){
    chomp($line);
    @fields = split "_", $line;
    $collection_time = $fields[0];
    $genotype = $fields[1];
    if ($genotype eq 'KO'){
        $gt = "Bmal1 KO";
    }
    if ($genotype eq 'WT'){
        $gt = "WT"
    }
 
    print OUTFILE "track $collection_time" . "_" . $genotype ."\n";
    print OUTFILE "container multiWig \n";
    print OUTFILE "shortLabel $collection_time" . "_" . $genotype ."\n";
    print OUTFILE "longLabel $gt - $collection_time - All - Unique \n";
    print OUTFILE "type bigWig \n";
    print OUTFILE "visibility full \n";
    print OUTFILE "aggregate transparentOverlay \n";
    print OUTFILE "showSubtrackColorOnUi on \n";
    print OUTFILE "configurable on \n";
    print OUTFILE "autoScale on \n";
    print OUTFILE "alwaysZero on \n \n";


	print OUTFILE "\t track max_cov_unique_byCondition_" . $line ."\n";
	print OUTFILE "\t bigDataUrl http://itmat.data.s3.amazonaws.com/fgdb/datasets/$datasetName/cov/max_cov_unique_byCondition_" . $hubName . ".bw \n"; 
	print OUTFILE "\t shortLabel max_cov_unique_byCondition_" . $hubName . "\n";
	print OUTFILE "\t longLabel Maximum coverage plot for all conditions $hubName unique \n";
	print OUTFILE "\t parent $collection_time" . "_" . $genotype ."\n";
	print OUTFILE "\t type bigWig \n";
	print OUTFILE "\t priority 1 \n";
	print OUTFILE "\t color 255,255,255 \n \n";

	print OUTFILE "\t track $line \n";
	print OUTFILE "\t bigDataUrl http://itmat.data.s3.amazonaws.com/fgdb/datasets/$datasetName/cov/$line" . ".bw \n"; 
	print OUTFILE "\t shortLabel $line \n"; 
	print OUTFILE "\t longLabel $gt - ZT $collection_time - All - Unique \n";
	print OUTFILE "\t parent $collection_time" . "_" . $genotype ."\n";
	print OUTFILE "\t type bigWig \n";
	print OUTFILE "\t priority 2 \n";
	print OUTFILE "\t color 255,0,0 \n \n";

}

close(INFILE);
close(OUTFILE);