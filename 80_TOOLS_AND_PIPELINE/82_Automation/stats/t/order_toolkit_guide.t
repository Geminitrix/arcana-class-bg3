#!/usr/bin/perl
# Tests for order_toolkit_guide.pl (ARC-0008).   perl t/order_toolkit_guide.t
use strict; use warnings; no warnings 'once';
use Test::More;
use File::Basename qw(dirname);
use Cwd qw(abs_path);
require(abs_path(dirname(__FILE__)) . '/../order_toolkit_guide.pl');

my %ord = ToolkitOrder::read_order(ToolkitOrder::slurp($ToolkitOrder::TEMPLATE));
is_deeply([sort keys %ord], [qw(Passive Projectile Rush Shout Status_BOOST Target Teleportation Zone)],
  'the template records the field order of the 8 Toolkit types');

my $guide = <<'MD';
## 3 · Stats Editor

### 01 · NEW · SpellData / Target · Example

| Field | `Target_A` | `Target_B` |
|---|---|---|
| Name | `A` | `B` |
| SpellAnimation | `x` | `y` |
| DisplayName | `A` | `B` |
| Using | `ShieldOfFaith` | `Bless` |
| DescriptionParams | — | — |
| SpellProperties | — | — |
| Level | `1` | `1` |

Notes — **A**:
- **From the parent:** SpellAnimation, Level.
- **Clears the parent:** SpellProperties (the parent has `ApplyStatus(X,100,-1)`).

### 02 · CHANGED · StatusData / Status_BOOST · `C`

| Field | Before | After |
|---|---|---|
| StatusPropertyFlags | `a` | `b` |
| Boosts | `c` | `d` |

## 4 · Localisation summary
MD

my ($new, $dropped) = ToolkitOrder::process($guide, %ord);
my ($t1) = $new =~ /(\| Field \| `Target_A`.*?)\n\n/s;
my @fields = map { (ToolkitOrder::cells($_))[0] } grep { !/^\|(---| Field)/ } split /\n/, $t1;
is_deeply(\@fields, ['Name', 'Using', 'Level', 'SpellProperties', 'DisplayName', 'Spell Animation'],
  'rows: Name, Using, then the Toolkit order, with the Toolkit labels');
is_deeply($dropped, ['01:DescriptionParams'], 'a row empty in every entry that clears nothing is dropped');
like($new, qr/^\| SpellProperties \| — \| — \|$/m, 'an empty row listed under "Clears the parent" stays');
like($new, qr/\| StatusPropertyFlags \| `a` \| `b` \|\n\| Boosts \| `c` \| `d` \|/, 'CHANGED blocks are left as they are');
like($new, qr/^- \*\*From the parent:\*\* Level, Spell Animation\.$/m, 'Notes lists follow the same order and labels');

my $live = "$ToolkitOrder::ROOT/50_ENGINEERING/55_Implementation_Specs/TOOLKIT_ARC-0008.md";
my $text = ToolkitOrder::slurp($live);
is((ToolkitOrder::process($text, %ord))[0], $text, 'TOOLKIT_ARC-0008 is already in Toolkit order (idempotent)');

done_testing();
