# ABSTRACT: Simple Stat on arrayref, like sum, mean, calc rate, etc
package SimpleR::Stat;

require Exporter;
@ISA    = qw(Exporter);
@EXPORT = qw( calc_rate calc_rate_arrayref format_percent calc_compare_rate);

use strict;
use warnings;

our $VERSION     = 0.01;


sub calc_rate {
    my ( $val, $sum ) = @_;
    return 0 unless ( $sum and $sum > 0 );
    $val ||= 0;

    my $rate = $val / $sum;
    return $rate;
} ## end sub calc_rate

sub calc_rate_arrayref {
    my ($r, %opt) = @_;
    my $fields = $opt{calc_fields} || [ 0 .. $#$r ];

    my $num=0;
    for my $i (@$fields){
        $r->[$i] ||=0;
        $num+=$r->[$i];
    }

    push @$r, $num;
    for my $i (@$fields){
        my $x = calc_rate($r->[$i], $num);
        $x = $opt{rate_sub}->($x) if(exists $opt{rate_sub});
        push @$r, $x;
    }

    return $r;
}

sub format_percent {
    my ( $rate, $format ) = @_;
    $format ||= "%.2f%%";
    $format = "%d%%" if ( $rate == 0 || $rate == 1 );
    return sprintf( $format, 100 * $rate );
}

sub calc_compare_rate {
    my ( $old, $new ) = @_;
    $old ||= 0;
    $new ||= 0;
    my $diff = $new-$old;

    my $rate = ($old == $new) ? 0 : 
    ($new == 0 ) ? -1 :
    ($old == 0 ) ? 1 :
    $diff / $old;
    return wantarray ? ($rate, $diff) : $rate;
} ## end sub calc_compare_rate

1;
