#!/usr/bin/perl -w

use PDL;
use PDL::IO::HDF;
use PDL::IO::HDF::VS;
use strict;

# Vdata test suite

print "1..7\n";

my $status;
#reading
my $Hid=PDL::IO::HDF::VS::_Hopen("test.HDF",$PDL::IO::HDF::DFACC_READ,2);
if ($Hid != -1 ) {print "ok 1\n";} else {print "not ok 1\n";}

PDL::IO::HDF::VS::_Vstart($Hid);

my $vdata_ref=PDL::IO::HDF::VS::_VSfind($Hid,'vdata_name');
if ($vdata_ref != -1 ) {print "ok 2\n";} else {print "not ok 2\n";}

my $vdata_id=PDL::IO::HDF::VS::_VSattach($Hid,$vdata_ref,"r");
if ($vdata_id != -1 ) {print "ok 3\n";} else {print "not ok 3\n";}

my $vdata_size=0;
my $n_records=0;
my $interlace=0;
my $fields="";
my $vdata_name="";
$status=PDL::IO::HDF::VS::_VSinquire($vdata_id, $n_records, $interlace, $fields, $vdata_size, $vdata_name);
if ($status) {print "ok 4\n";} else {print "not ok 4\n";}

my @tfields=split(",",$fields);
my $data_type=PDL::IO::HDF::VS::_VFfieldtype($vdata_id,0);
#print $data_type . "\n";

my $data=&{$PDL::IO::HDF::SDinvtypeTMAP{$data_type}}(ones(10));
$status=PDL::IO::HDF::VS::_VSread($vdata_id,$data,$n_records,$interlace);
if ($status) {print "ok 5\n";} else {print "not ok 5\n";}

my $expected_data=sequence(10);
my $inok=$data->where($data != $expected_data);
if ($inok->nelem == 0) {print "ok 6\n";} else {print "not ok 6\n";}


PDL::IO::HDF::VS::_VSdetach($vdata_id);

PDL::IO::HDF::VS::_Vend($Hid);

$status=PDL::IO::HDF::VS::_Hclose($Hid);
if ($status) {print "ok 7\n";} else {print "not ok 7\n";}
