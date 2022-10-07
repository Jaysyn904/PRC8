# Perl script for generating the Spell Router scripts.
# by OldManWhistler

# spells.2da should exist in the same directory as this script.
# The new dem_router.2da and spells.2da files will be created
# in a sub-directory called tmp.

# This script makes it very fast to create a new hakpak for a
# modified spells.2DA file.
# If you are trying to run perl on a Windows machine,
# then install http://www.activestate.com/Products/ActivePerl/

use strict;
use FileHandle;

# Name and location of the files we are working with.
my $input_file  = "../2das/spells.2da";
#my $router_file = "dem_router.2da";
my $lookup_file = "../scripts/look2daint.nss";

my $debug = 0;

my %feats = ();

main();

sub main() {
    if ( !-f $input_file ) {
        print "Could not find $input_file.\n";
        <STDIN>;
        exit(0);
    }
    #if (! -d "tmp") { system("mkdir tmp"); }
    #my $rfh = new FileHandle(">$router_file")
    #  || die "Error: could not open $router_file for writing\n";
    my $lfh = new FileHandle(">$lookup_file")
      || die "Error: could not open $lookup_file for writing\n";

    # First pass, identify feats
    my $ifh = new FileHandle("$input_file")
      || die "Error: could not open $input_file for reading\n";
    while (<$ifh>) {
        chomp;
        my @data   = split( /\s+/, $_ );
        my $num    = $data[0];
        my $altmsg = $data[50];
        my $featid = $data[52];

        if ( ( $altmsg !~ m/\*\*\*\*/ ) || ( $featid !~ m/\*\*\*\*/ ) ) {
            if ($debug) { print "$data[1] is a feat.\n"; }
            $feats{$num} = 1;
        }
        else {
            $feats{$num} = 0;
        }
    }
    close($ifh);

# Second pass, read in the original file and set up innate overrides for sub-radial spells.
# ie: spell X has subradial spells Y and Z. The innate columns for Y/Z are not defined
# but the innate columns for X are defined. So make Y/Z copy the innate column for X.
    my %innate_bard    = ();
    my %innate_cleric  = ();
    my %innate_druid   = ();
    my %innate_paladin = ();
    my %innate_ranger  = ();
    my %innate_wizsorc = ();
    my %innate_innate  = ();
    $ifh = new FileHandle("$input_file")
      || die "Error: could not open $input_file for reading\n";

    while (<$ifh>) {
        chomp;
        my @data = split( /\s+/, $_ );
        my $num  = $data[0];

        # Skip over empty lines.
        if ( ( $num =~ m/2DA/ ) || ( $num eq "" ) ) {
            next;
        }

        my $bard    = $data[10];
        my $cleric  = $data[11];
        my $druid   = $data[12];
        my $paladin = $data[13];
        my $ranger  = $data[14];
        my $wizsorc = $data[15];
        my $innate  = $data[16];
        my $subrad1 = $data[39];
        my $subrad2 = $data[40];
        my $subrad3 = $data[41];
        my $subrad4 = $data[42];
        my $subrad5 = $data[43];


        foreach ( $num, $subrad1, $subrad2, $subrad3, $subrad4, $subrad5 ) {
            if ( $_ =~ m/\*\*\*\*/ ) {
                next;
            }
            if ($debug) {
                print "$data[1]: Setting up innate data for spell # $_\n";
            }
            &updateInnate( $_, \%innate_bard,    $bard,    $num );
            &updateInnate( $_, \%innate_cleric,  $cleric,  $num );
            &updateInnate( $_, \%innate_druid,   $druid,   $num );
            &updateInnate( $_, \%innate_paladin, $paladin, $num );
            &updateInnate( $_, \%innate_ranger,  $ranger,  $num );
            &updateInnate( $_, \%innate_wizsorc, $wizsorc, $num );
            &updateInnate( $_, \%innate_innate,  $innate,  $num );
            if ($debug) {
                print "\t$bard\t$cleric\t$druid\t$paladin\t$ranger\t$wizsorc\t$innate\n";
                print "\t$innate_bard{$_}\t$innate_cleric{$_}\t$innate_druid{$_}\t$innate_paladin{$_}\t$innate_ranger{$_}\t$innate_wizsorc{$_}\t$innate_innate{$_}\n";
            }
        }
    }
    close($ifh);

    # Third pass, read in the original file and write out the routed files.
    $ifh = new FileHandle("$input_file")
      || die "Error: could not open $input_file for reading\n";
      
    printf $lfh "void main()\n{\n";  
    while (<$ifh>) {
        chomp;
        my @data   = split( /\s+/, $_ );
        my $num    = $data[0];
        my $label  = $data[1];
        my $script = $data[9];

        if ( $label =~ m/Label/ ) {

            # This is the label line.
#            print $rfh "        Label                                   SpellScript\n";
#            print $lfh "$_\n";
            next;
        }

        if ( ( $num =~ m/2DA/ ) || ( $num eq "" ) ) {

            # This is a header line.
#            print $rfh "$_\n";
#            print $lfh "$_\n";
            next;
        }

        my $routed_script = "Spell_Hak";
        if ( $feats{$num} ) {
            $routed_script = $script;
        }




 #   SetLocalString(module, "PRC_PACK_SPELL_TYPE_" + IntToString(spell_id), element);
#SetLocalString(module, "PRC_PACK_SPELL_TYPE_0",element); 

#if (($label ne "****"))
#{ 

if (($data[10] ne "****") || ($data[11] ne "****") || ($data[12] ne "****") || ($data[13] ne "****") || ($data[14] ne "****") || ($data[15] ne "****"))
{

  if ($data[2] ne "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_NAME_%s\", \"%s\");\n",$num,$data[2];
}
 if ($data[2] eq "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_NAME_%s\", \"\");\n",$num,$data[2];
}

  if ($data[37] ne "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_TYPE_%s\", \"%s\");\n",$num,$data[37];
}
 if ($data[37] eq "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_TYPE_%s\", \"\");\n",$num,$data[37];
}

  if ($data[16] ne "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_INNATE_LEVEL_%s\", \"%s\");\n",$num,$data[16];
}
 if ($data[16] eq "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_INNATE_LEVEL_%s\", \"\");\n",$num,$data[16];
}

  if ($innate_wizsorc{$num} ne "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_LEVEL_%s\", \"%s\");\n",$num,$innate_wizsorc{$num};
}
 if ($innate_wizsorc{$num} eq "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_LEVEL_%s\", \"\");\n",$num,$innate_wizsorc{$num};
}

  if ($innate_cleric{$num} ne "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_CLERIC_LEVEL_%s\", \"%s\");\n",$num,$innate_cleric{$num};
}
  if ($innate_cleric{$num} eq "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_CLERIC_LEVEL_%s\", \"\");\n",$num,$innate_cleric{$num};
}

  if ($data[6] ne "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_VS_%s\", \"%s\");\n",$num,$data[6];
}
  if ($data[6] eq "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_VS_%s\", \"\");\n",$num,$data[6];
}

  if ($data[4] ne "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_SCHOOL_%s\", \"%s\");\n",$num,$data[4];
}
  if ($data[4] eq "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_SCHOOL_%s\", \"\");\n",$num,$data[4];
}

  if ($data[51] ne "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_HOSTILESETTING_%s\", \"%s\");\n",$num,$data[51];
}
 if ($data[51] eq "****"){
        printf $lfh "    SetLocalString(GetModule(), \"PRC_PACK_SPELL_HOSTILESETTING_%s\", \"\");\n",$num,$data[51];
}

print $lfh "\n";
}
#}
    }
    printf $lfh "}";
    
    close($ifh);
    #close($rfh);
    close($lfh);
}

# This updates a reference for an innate value based on the result.

sub updateInnate {
    my ( $i, $ref, $innate_val, $parent_spell ) = @_;

    # If the current spell is a feat then do not update its
    # subradial spells.
    if (   ( $feats{$parent_spell} )
        && ( $i ne $parent_spell ) )
    {
        return;
    }

    if ( !defined $ref->{$i} ) {
        $ref->{$i} = $innate_val;
    }
    if (
        ( !$feats{$i} )            && # Don't update the innate values for feats
        ( !$feats{$parent_spell} ) && # Don't update the innate values for feats
        ( $innate_val !~ m/\*\*\*\*/ )
        &&    # Don't update the innate value with garbage
        ( ( $ref->{$i} =~ m/\*\*\*\*/ ) || ( $innate_val < $ref->{$i} ) )
      )
    {
        if ($debug) {
            print "\t$i switching innate $ref->{$i} for $innate_val\n";
        }
        $ref->{$i} = $innate_val;
    }
}
