#!/usr/bin/perl -w

use PDL;
use PDL::IO::HDF;
use PDL::IO::HDF::VS;
use strict;
use Data::Dumper;

# Vdata test suite


print "1..2\n";
# vdata OO interface test suite

my $vdataOBJ=PDL::IO::HDF::VS->new('-montest3.HDF');

my $data0 = PDL::long( sequence(100,3) );
my $data1 = PDL::byte( sequence(100,2) );
my $data2 = PDL::short( sequence(100,1) );
my $data3 = PDL::float( sequence(100,4) * 1.13);

my $data = [$data0, $data1, $data2, $data3];

my $field = "fiel0,fiel1,filed3,foo4";

my $res = $vdataOBJ->VSwrite("NOM_VD:ma_class", $PDL::IO::HDF::FULL_INTERLACE, $field, $data);
if ($res) {print "ok 1\n";} else {print "not ok 1\n";}
print "$res\n";

#my $res = $vdataOBJ->VSwrite("NOM_VD:ma_class", "champ_foo", $data0);
#print "res : $res\n";

$res = $vdataOBJ->close;
if ($res) {print "ok 2\n";} else {print "not ok 2\n";}




