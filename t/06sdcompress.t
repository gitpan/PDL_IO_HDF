#!/usr/bin/perl -w

use PDL;
use PDL::IO::HDF;
use PDL::IO::HDF::SD;
use strict;
use Data::Dumper;

# Compression d'un dataset

print "1..3\n";

my $HDFobj = PDL::IO::HDF::SD->new("-montest.HDF");

#print Data::Dumper->Dump([$HDFobj], [qw(HDFobj)]);
#Define some data
my $data = PDL::short( ones(5000,5) );
#my $data = ones(5000,5);

#Put data in file as 'myData' dataset
#with the names of dimensions ('dim1' and 'dim2')
my $res = $HDFobj->SDput("myData", $data , ['dim1','dim2']);
if ($res != 0 ) {print "ok 1\n";} else {print "not ok 1\n";}

#compression du dataset
$res = $HDFobj->SDsetcompress("myData", 5);
if ($res != 0 ) {print "ok 2\n";} else {print "not ok 2\n";}

$HDFobj->SDput("myData", $data , ['dim1','dim2']);
 
#print Data::Dumper->Dump([$HDFobj], [qw(HDFobj)]);

$data = $HDFobj->SDget("myData");
if ($data->nelem != 0 ) {print "ok 3\n";} else {print "not ok 3\n";}
#print "inf : ".$data->info."\n";

$HDFobj->close();
#$HDFobj = undef;

#$HDFobj = PDL::IO::HDF::SD->new("/espace/SAR/bchapron/BSAR/envisat/wvs/19970601/hdf/test.hdf");
#print Data::Dumper->Dump([$HDFobj], [qw(HDFobj)]);

#my $real_spc = $HDFobj->SDget("real_spectra");
#print "info get : ".$real_spc->info."\n";

#$HDFobj->close();

