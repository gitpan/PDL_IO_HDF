#!/usr/bin/perl -w

use PDL;
use PDL::IO::HDF;
use PDL::IO::HDF::VS;
use strict;

# Vdata test suite

print "1..8\n";

my $status;

# creating

my $Hid=PDL::IO::HDF::VS::_Hopen("test.HDF",$PDL::IO::HDF::DFACC_CREATE,2);
if ($Hid != -1 ) {print "ok 1\n";} else {print "not ok 1\n";}

PDL::IO::HDF::VS::_Vstart($Hid);

my $vdata_id=PDL::IO::HDF::VS::_VSattach($Hid,-1,"w");
PDL::IO::HDF::VS::_VSsetname($vdata_id,'vdata_name');
PDL::IO::HDF::VS::_VSsetclass($vdata_id,'vdata_class');

my $vdata_ref=PDL::IO::HDF::VS::_VSgetid($Hid,-1);
if ($vdata_ref != -1 ) {print "ok 2\n";} else {print "not ok 2\n";}

my $name="";
PDL::IO::HDF::VS::_VSgetname($vdata_id,$name);
if ($name eq "vdata_name" ) {print "ok 3\n";} else {print "not ok 3\n";}

my $class="";
PDL::IO::HDF::VS::_VSgetclass($vdata_id,$class);
if ($class eq "vdata_class" ) {print "ok 4\n";} else {print "not ok 4\n";}

my $data=PDL::float sequence(10);
my $HDFtype=$PDL::IO::HDF::SDtypeTMAP{$data->get_datatype};

$status=PDL::IO::HDF::VS::_VSfdefine($vdata_id,'PX',$HDFtype,1);
if ( $status ) {print "ok 5\n";} else {print "not ok 5\n";}

$status=PDL::IO::HDF::VS::_VSsetfields($vdata_id,"PX");
if ($status) {print "ok 6\n";} else {print "not ok 6\n";}


$status=PDL::IO::HDF::VS::_VSwrite($vdata_id,$data,10,$PDL::IO::HDF::FULL_INTERLACE);
if ($status) {print "ok 7\n";} else {print "not ok 7\n";}

PDL::IO::HDF::VS::_VSdetach($vdata_id);

PDL::IO::HDF::VS::_Vend($Hid);

$status=PDL::IO::HDF::VS::_Hclose($Hid);
if ($status) {print "ok 8\n";} else {print "not ok 8\n";}



