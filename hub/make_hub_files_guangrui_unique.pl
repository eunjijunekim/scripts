$sampleinfo_file = $ARGV[0]; #sampleinfo file
$datasetName = $ARGV[1]; # e.g 13_yang_rnaseq1
$hubName = $ARGV[2]; # e.g gy
$studyTitle = $ARGV[3]; # e.g "GY_bmal1KO_liver RNA-seq - 48 samples"

$hubfile = $hubName . ".txt";
open(OUTFILE, ">$hubfile");
print OUTFILE "hub s3.amazonaws.com/itmat.data/fgdb/datasets/$datasetName/cov/$hubName/ \n";
print OUTFILE "shortLabel $hubName \n";
print OUTFILE "longLabel $studyTitle \n";
print OUTFILE "genomesFile " . $hubName . "_genome.txt \n";
print OUTFILE "email eunji.june.kim\@gmail.com";
close(OUTFILE);

$genome_file = $hubName . "_genome.txt";
open(OUTFILE, ">$genome_file");
print OUTFILE "genome mm9 \n";
print OUTFILE "trackDb mm9/". $hubName ."_trackDb.txt";
close(OUTFILE);

$track_file = "mm9/" . $hubName . "_trackDb.txt";
open(OUTFILE, ">$track_file");

open(INFILE, $sampleinfo_file); #sample_info file
while ($line = <INFILE>){
    chomp($line);
    @fields = split " ", $line;
    $sample_name = $fields[0];
    @sample = split "_", $sample_name;
    $collection_time = $sample[0];
    $genotype = $sample[1];
    $rep = $fields[1];
    $rep_num = substr($rep, -1);
    if ($genotype eq 'KO'){
        $gt = "Bmal1 KO";
    }
    if ($genotype eq 'control'){
        $gt = "WT"
    }
    print OUTFILE "track $sample_name \n";
    print OUTFILE "container multiWig \n";
    print OUTFILE "shortLabel $sample_name \n";
    print OUTFILE "longLabel $gt - $collection_time - Replicate $rep_num - Sample $sample_name Unique \n";
    print OUTFILE "type bigWig \n";
    print OUTFILE "visibility full \n";
    print OUTFILE "aggregate transparentOverlay \n";
    print OUTFILE "showSubtrackColorOnUi on \n";
    print OUTFILE "configurable on \n";
    print OUTFILE "autoScale on \n";
    print OUTFILE "alwaysZero on \n \n";


	print OUTFILE "\t track max_cov_unique_" . $sample_name ."\n";
	print OUTFILE "\t bigDataUrl http://itmat.data.s3.amazonaws.com/fgdb/datasets/$datasetName/cov/max_cov_unique_" . $hubName . ".bw \n"; 
	print OUTFILE "\t shortLabel max_cov_unique_" . $hubName . "\n";
	print OUTFILE "\t longLabel Maximum coverage plot for $hubName unique \n";
	print OUTFILE "\t parent $sample_name \n";
	print OUTFILE "\t type bigWig \n";
	print OUTFILE "\t priority 1 \n";
	print OUTFILE "\t color 255,255,255 \n \n";

	print OUTFILE "\t track $sample_name" . "_Unique \n";
	print OUTFILE "\t bigDataUrl http://itmat.data.s3.amazonaws.com/fgdb/datasets/$datasetName/cov/Sample_" . $sample_name . ".Unique.bw \n"; 
	print OUTFILE "\t shortLabel $sample_name Unique \n"; 
	print OUTFILE "\t longLabel $gt - ZT $collection_time - Replicate $rep_num - Sample $sample_name Unique \n";
	print OUTFILE "\t parent $sample_name \n";
	print OUTFILE "\t type bigWig \n";
	print OUTFILE "\t priority 2 \n";
	print OUTFILE "\t color 255,0,0 \n \n";

}

close(INFILE);
close(OUTFILE);