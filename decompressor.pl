#!/usr/bin/perl -w

use utf8;
use v5.28;
use strict;
use Pod::Usage;
use SVN::Notify;
use Term::ANSIColor;

$| = 1;
binmode STDOUT, ":utf8";

my $file = $ARGV[0];
my ($rst, $rd) = (color('reset'), color('red'));

unless (defined $file && -e $file && -r $file && !-z $file){
  pod2usage(1);
}

my %ucomp = (
  "7z" => "7z x",     zip  => "unzip",
    z  => "gzip -d",  Z    => "gzip -d",
   xz  => "tar xfJ",  rz   => "rzip -d",
  deb  => "dpkg -x",  rar  => "unrar x",
  xar  => "xar -xvf", tar  => "tar xvf",
   gz  => "tar xvzf", pkg  => "xar -xvf", 
  bz2  => "tar xvjf", tgz  => "tar -xvzf", 
  arj  => "arj e -r -y"
);

sub check_util {
  unless (SVN::Notify->find_exe($_[0])) {
    say($rd."[!] $_[0] is not installed...".$rst);
    exit 1;
  }
}

sub decompress {
  if ($file =~ m/.*[.]([\w]+)$/i){
    my @util = split /\s+/, "$ucomp{$1}";
    if ($^O eq "darwin" && $util[0] eq "arj") {
      &check_util("unarj");
    } else {
      &check_util($util[0]);
    }
    if    ($1 eq "deb") { `$ucomp{$1} $file $ENV{'PWD'}`; }
    elsif ($1 eq "arj") { $^O eq "darwin" ? `unarj e $file` : `$ucomp{$1} $file`; }
    else { `$ucomp{$1} $file`; }
  }
  else {
    say($rd."[!] Couldn't decompress the file...".$rst);
  }
}

&decompress($file);
__END__

=head1 NAME

uc - A linux/macOS decompressing utility.

=head1 SYNOPSIS

uc [file]

=head1 DESCRIPTION

A small decompressing utility, for linux and macOS operating systems, able
to decompress over 10 different filetypes with a single command, automatically.

=head1 EXAMPLE

uc test.bz2

=cut