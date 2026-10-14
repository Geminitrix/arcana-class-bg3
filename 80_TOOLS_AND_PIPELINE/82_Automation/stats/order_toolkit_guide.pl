#!/usr/bin/perl
# Puts the Stats Editor tables of a Toolkit guide (TOOLKIT_ARC-####.md) in the Toolkit's own field order.
# The order lists are read from the template (_TEMPLATE_TOOLKIT_GUIDE.md, "Toolkit field order").
#  - NEW blocks only (CHANGED blocks are left as they are); rows sorted Name, Using, then the Toolkit order;
#  - stats names become the Toolkit labels (SpellAnimation -> Spell Animation, VerbalIntent -> Intent, ...);
#  - a row that is `—` for every entry is dropped, unless the block's Notes list it under "Clears the parent";
#  - the From the parent / Ours / Clears the parent lists in the Notes are sorted the same way.
# usage: order_toolkit_guide.pl GUIDE.md            report what would change
#        order_toolkit_guide.pl --apply GUIDE.md    rewrite the guide
use strict; use warnings;

package ToolkitOrder;

our $ROOT = 'C:/Lumox Studios/Arcana Class';
our $TEMPLATE = "$ROOT/50_ENGINEERING/55_Implementation_Specs/_TEMPLATE_TOOLKIT_GUIDE.md";
our %LABEL = (SpellAnimation => 'Spell Animation', VerbalIntent => 'Intent', SpellStyleGroup => 'Spell Style Group',
              MemoryCost => 'Memory Cost', DualWieldingSpellAnimation => 'Dual Wielding Spell Animation');

# { Type => { Field => rank } } from the "**Type:** Owner → Level → …" lines.
sub read_order {
  my ($text) = @_; my %ord;
  for (split /\n/, $text) {
    next unless /^\*\*(\w+):\*\* (Owner → .*)$/;
    my ($type, $list) = ($1, $2); my @x = split / → /, $list; $ord{$type} = { map { $x[$_] => $_ } 0..$#x };
  }
  return %ord;
}

sub cells { my ($row) = @_; (my $x = $row) =~ s/^\| //; $x =~ s/ \|$//; return split / \| /, $x, -1 }

# Splits a Notes list on top-level commas/semicolons (not inside parentheses or `code`).
sub items {
  my ($body) = @_; my @out; my ($depth, $code, $cur) = (0, 0, '');
  for my $ch (split //, $body) {
    $code = !$code if $ch eq '`';
    if (!$code) { $depth++ if $ch eq '('; $depth-- if $ch eq ')' }
    if (($ch eq ',' || $ch eq ';') && !$depth && !$code) { push @out, $cur; $cur = '' } else { $cur .= $ch }
  }
  push @out, $cur; s/^\s+|\s+$//g for @out; return grep { length } @out;
}

sub wrap {
  my ($text, $width) = @_; my ($line, @w) = ('');
  for my $w (split / /, $text) {
    if ($line ne '' && length($line) + 1 + length($w) > $width) { push @w, $line; $line = "  $w" }
    else { $line = $line eq '' ? $w : "$line $w" }
  }
  return (@w, $line);
}

# Returns (new text, [dropped "block:field"], [unknown "block:field"]).
sub process {
  my ($text, %ord) = @_;
  my @L = split /\n/, $text, -1;
  my (@out, @dropped, @unknown); my ($on, $blk, $type) = (0, '', '');
  my $rank = sub { my ($name) = @_; return -2 if $name eq 'Name'; return -1 if $name eq 'Using';
    my $r = $ord{$type}{$name}; push @unknown, "$blk:$name" unless defined $r; $r // 1e6 };
  for (my $i = 0; $i < @L; $i++) {
    my $l = $L[$i];
    $on = 1 if $l =~ /^## 3 /; $on = 0 if $l =~ /^## [4-9] /;
    if ($l =~ /^###/) { ($blk, $type) = $on && $l =~ /^### (\S+) · NEW · [^\/]+\/ (\S+)/ ? ($1, $2) : ('', '') }
    my $active = $on && $type && $ord{$type};
    if ($active && $l =~ /^\| Field \|/) {
      my $j = $i + 2; my @rows; push @rows, $L[$j++] while $j < @L && $L[$j] =~ /^\| /;
      my $k = $j; $k++ while $k < @L && $L[$k] !~ /^###|^## /;
      my $notes = join "\n", @L[$j .. $k - 1];
      my %clears; while ($notes =~ /\*\*Clears the parent:\*\*(.*?)(?=\n- |\n\n|\z)/gs) {
        (my $b = $1) =~ s/\n\s+/ /g; $clears{(/^([\w ]+?)(?: \(|$)/)[0] // $_} = 1 for items($b) }
      my @keep;
      for my $r (@rows) {
        my @c = cells($r); $c[0] = $LABEL{$c[0]} // $c[0];
        if (!grep { $_ ne '—' } @c[1..$#c] and !$clears{$c[0]}) { push @dropped, "$blk:$c[0]"; next }
        push @keep, [$rank->($c[0]), '| ' . join(' | ', @c) . ' |'];
      }
      push @out, $l, $L[$i+1], map { $_->[1] } sort { $a->[0] <=> $b->[0] } @keep;
      $i = $j - 1; next;
    }
    if ($active && $l =~ /^(- \*\*(?:From the parent|Ours|Clears the parent):\*\* )(.*)$/) {
      my ($head, $body) = ($1, $2);
      while ($i + 1 < @L && $L[$i+1] =~ /^  \S/) { (my $c = $L[++$i]) =~ s/^\s+//; $body .= " $c" }
      my $tail = $body =~ s/\.\s+(Icon is a suggestion\.)$// ? " $1" : ''; $body =~ s/\.$//;
      my @it = map { my $x = $_; my ($n) = $x =~ /^(\w+)/; $x =~ s/^\Q$n\E/$LABEL{$n}/ if $n && $LABEL{$n}; $x } items($body);
      my $key = sub { ($_[0] =~ /^([\w ]+?)(?: \(|$)/)[0] // $_[0] };
      @it = sort { $rank->($key->($a)) <=> $rank->($key->($b)) } @it;
      push @out, wrap($head . join(', ', @it) . '.' . $tail, 118); next;
    }
    push @out, $l;
  }
  return (join("\n", @out), \@dropped, \@unknown);
}

sub slurp { my ($f) = @_; open my $h, '<:raw', $f or die "$f: $!"; local $/; my $s = <$h>; $s =~ s/\r\n/\n/g; $s }

package main;

unless (caller) {
  my $apply = @ARGV && $ARGV[0] eq '--apply' ? shift : 0;
  my $guide = shift or die "usage: order_toolkit_guide.pl [--apply] GUIDE.md\n";
  my %ord = ToolkitOrder::read_order(ToolkitOrder::slurp($ToolkitOrder::TEMPLATE));
  die "no field order found in $ToolkitOrder::TEMPLATE\n" unless %ord;
  my $old = ToolkitOrder::slurp($guide);
  my ($new, $dropped, $unknown) = ToolkitOrder::process($old, %ord);
  print "dropped (empty in every entry, clears nothing): @$dropped\n" if @$dropped;
  print "NOT IN THE TOOLKIT ORDER (check the label): @$unknown\n" if @$unknown;
  if ($new eq $old) { print "$guide: already in Toolkit order\n"; exit 0 }
  if ($apply) { open my $h, '>:raw', $guide or die $!; print $h $new; close $h; print "$guide: rewritten\n" }
  else { print "$guide: would change (run with --apply)\n"; exit 1 }
}
1;
