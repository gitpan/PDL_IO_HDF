#package;

# This file contain functions to build .pd


# Define a low-level perl interface to HDF from these definitions.
sub create_low_level {

# This file must be modified to only include 
# netCDF 3 function definitions.
# Also, all C function declarations must be on one line.
  my $defn = shift;
  my @lines = split (/\n/, $defn);

  foreach (@lines) {

    next if (/^\#/);  # Skip commented out lines
    next if (/^\s*$/); # Skip blank lines

    my ($return_type, $func_name, $parms, $add) = /^(\w+\**)\s+(\w+)\((.+)\)(\+*\d*)\;/;
    my @parms = split (/,/, $parms);

    my @vars  = ();
    my @types = ();
    my %output = ();
    foreach $parm (@parms) {

      my ($varname) = ($parm =~ /(\w+)$/);
      $parm =~ s/$varname//; # parm now contains the full C type
      $output{$varname} = 1 if (($parm =~ /\*/) && ($parm !~ /const/));
      $parm =~ s/const //;  # get rid of 'const' in C type
      $parm =~ s/^\s+//;
      $parm =~ s/\s+$//;    # pare off the variable type from 'parm'
      
      push (@vars, $varname);
      push (@types, $parm);

    }

    my $xsout = '';
    $xsout .= "$return_type\n";
    $xsout .= "_$func_name (" . join (", ", @vars) . ")\n";
    for (my $i=0;$i<@vars;$i++) {
      $xsout .= "\t$types[$i]\t$vars[$i]\n";
    }
    
    $xsout .= "CODE:\n";
    if(defined $add){ $xsout .= "\tRETVAL = $add + $func_name ("; }
    else{ $xsout .= "\tRETVAL = $func_name ("; }
    for (my $i=0;$i<@vars;$i++) {
      if ($types[$i] =~ /PDL/) {
        ($type = $types[$i]) =~ s/PDL//; # Get rid of PDL type when writine xs CODE section
        $xsout .= "($type)$vars[$i]"."->data,";
      } else {
        $xsout .= "$vars[$i],";
      }
    }
    chop ($xsout);  # remove last comma
    $xsout .= ");\n";
    $xsout .= "OUTPUT:\n";
    $xsout .= "\tRETVAL\n";
    foreach $var (keys %output) {
      $xsout .= "\t$var\n";
    }
    $xsout .= "\n\n";

    pp_addxs ('', $xsout);
  }

}

sub create_generic
{
  my $defn = shift;
  my @alltype = ('char', 'unsigned char', 'short int', 'unsigned short int',
		 'long int', 'unsigned long int', 'float', 'double');
  my @nametype = ('char', 'uchar', 'short', 'ushort',
		  'long', 'ulong', 'float', 'double');

  for(my $i=0; $i<=$#alltype; $i++)
  {
     my $xsout = $defn;
     $xsout =~ s/GENERIC/$alltype[$i]/eg;     
     $xsout =~ s/NAME/$nametype[$i]/eg;     
     pp_addxs ('', $xsout);
  }
}


1;
