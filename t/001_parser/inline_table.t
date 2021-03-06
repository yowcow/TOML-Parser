use strict;
use warnings;
use utf8;

use Test::More  tests => 2;
use Storable qw/thaw/;
use MIME::Base64;

use TOML::Parser;

sub inflate_datetime {
    my $dt = shift;
    $dt =~ s/Z$/+00:00/;
    return $dt;
}

my $toml = do { local $/; <DATA> };

my $expected = thaw(decode_base64(<<'__EXPECTED__'));
BQoDAAAAAwQDAAAAAgiBAAAAAXgIggAAAAF5AAAABXBvaW50BAIAAAADBAMAAAADCIIAAAABeQiD
AAAAAXoIgQAAAAF4BAMAAAADCIkAAAABegiHAAAAAXgIiAAAAAF5BAMAAAADCIIAAAABeAiIAAAA
AXoIhAAAAAF5AAAABnBvaW50cwQDAAAAAgoOUHJlc3Rvbi1XZXJuZXIAAAAEbGFzdAoDVG9tAAAA
BWZpcnN0AAAABG5hbWU=

__EXPECTED__

for my $strict (0, 1) {
    my $parser = TOML::Parser->new(inflate_datetime => \&inflate_datetime, strict_mode => $strict);
    my $data   = $parser->parse($toml);
    note explain { data => $data, expected => $expected } if $ENV{AUTHOR_TESTING};
    is_deeply $data => $expected, "inline_table.toml: strict: $strict";
}

__DATA__
name = { first = "Tom", last = "Preston-Werner" }
point = { x = 1, y = 2 }

points = [ { x = 1, y = 2, z = 3 },
           { x = 7, y = 8, z = 9 },
           { x = 2, y = 4, z = 8 } ]

