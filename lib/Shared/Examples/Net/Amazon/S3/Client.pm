package Shared::Examples::Net::Amazon::S3::Client;

use strict;
use warnings;

use parent qw[ Exporter::Tiny ];

use Hash::Util;
use Sub::Override;
use Test::Deep;

use Net::Amazon::S3::Client;

our @EXPORT_OK = (
    qw[ expect_signed_uri ],
);

sub expect_signed_uri {
    my ($title, %params) = @_;

    Hash::Util::lock_keys %params,
        qw[ with_client ],
        qw[ with_bucket ],
        qw[ with_region ],
        qw[ with_key ],
        qw[ with_expire_at ],
        qw[ expect_uri ],
        ;

    my $guard = Sub::Override->new (
        'Net::Amazon::S3::Bucket::region' => sub { $params{with_region } },
    );

    my $got = $params{with_client}
        ->bucket (
            name    => $params{with_bucket},
        )
        ->object (
            key     => $params{with_key},
            expires => $params{with_expire_at},
        )
        ->query_string_authentication_uri
        ;

    cmp_deeply $got, $params{expect_uri}, $title;
}

1;
