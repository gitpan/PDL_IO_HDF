#!/usr/bin/perl -w

use PDL;
#use PDL::IO::HDF;
use PDL::IO::HDF::VS;
use strict;

# Vgroup test suite

print "1..5\n";



my $Hid=PDL::IO::HDF::VS::_Hopen("test.HDF",$PDL::IO::HDF::DFACC_CREATE,2);
if ($Hid != -1 ) {print "ok 1\n";} else {print "not ok 1\n";}

PDL::IO::HDF::VS::_Vstart($Hid);

my $vgroup_id=PDL::IO::HDF::VS::_Vattach($Hid,-1,"w");
PDL::IO::HDF::VS::_Vsetname($vgroup_id,'vgroup_name');
PDL::IO::HDF::VS::_Vsetclass($vgroup_id,'vgroup_class');

my $vgroup_ref=PDL::IO::HDF::VS::_Vgetid($Hid,-1);
if ($vgroup_ref != -1 ) {print "ok 2\n";} else {print "not ok 2\n";}

my $name="";
PDL::IO::HDF::VS::_Vgetname($vgroup_id,$name);
if ($name eq "vgroup_name" ) {print "ok 3\n";} else {print "not ok 3\n";}

my $class="";
PDL::IO::HDF::VS::_Vgetclass($vgroup_id,$class);
if ($class eq "vgroup_class" ) {print "ok 4\n";} else {print "not ok 4\n";}

PDL::IO::HDF::VS::_Vdetach($vgroup_id);

PDL::IO::HDF::VS::_Vend($Hid);

my $status=PDL::IO::HDF::VS::_Hclose($Hid);
if ($status) {print "ok 5\n";} else {print "not ok 5\n";}


