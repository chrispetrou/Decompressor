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
  dmg  => "7z x",     jar  => "unzip",
  z    => "gzip -d",  war  => "unzip",
  Z    => "gzip -d",  apk  => "unzip",
  xz   => "tar xfJ",  deb  => "dpkg -x",
  rz   => "rzip -d",  lz   => "lzip -d",
  rar  => "unrar x",  pkg  => "xar -xvf",
  tar  => "tar xvf",  xar  => "xar -xvf",
  gz   => "tar xvzf", tgz  => "tar xvzf",
  bz2  => "tar xvjf", arj  => "arj e -r -y"
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
    elsif ($1 eq "apk") { my @dir = split /\.apk$/, $file; `$ucomp{$1} $file -d $dir[0]`; }
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
to decompress a wide range of archive formats with a single command, automatically.

=head1 EXAMPLE

uc test.bz2

=cut