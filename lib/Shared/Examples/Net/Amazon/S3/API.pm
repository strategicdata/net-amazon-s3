package Shared::Examples::Net::Amazon::S3::API;

use strict;
use warnings;

use parent qw[ Exporter::Tiny ];

use Hash::Util;
use Test::Deep;

use Net::Amazon::S3;

our @EXPORT_OK = (
    qw[ expect_signed_uri ],
);

sub expect_signed_uri {
    my ($title, %params) = @_;

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    Hash::Util::lock_keys %params,
        qw[ with_s3 ],
        qw[ with_bucket ],
        qw[ with_region ],
        qw[ with_key ],
        qw[ with_expire_at ],
        qw[ expect_uri ],
        ;

    my $got = Net::Amazon::S3::Bucket
        ->new ({
            account => $params{with_s3},
            bucket  => $params{with_bucket},
            region  => $params{with_region},
        })
        ->query_string_authentication_uri (
            $params{with_key},
            $params{with_expire_at}
        );

    cmp_deeply $got, $params{expect_uri}, $title;
}

1;
