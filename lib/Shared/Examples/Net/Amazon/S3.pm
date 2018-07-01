package Shared::Examples::Net::Amazon::S3;

use strict;
use warnings;

use parent qw[ Exporter::Tiny ];

use Hash::Util;
use Test::More;

use Net::Amazon::S3;

use Shared::Examples::Net::Amazon::S3::API;
use Shared::Examples::Net::Amazon::S3::Client;

our @EXPORT_OK = (
    qw[ s3_api_with_signature_4 ],
    qw[ s3_api_with_signature_2 ],
    qw[ expect_net_amazon_s3_feature ],
);

sub s3_api_with_signature_4 {
    Net::Amazon::S3->new (
        aws_access_key_id     => 'AKIDEXAMPLE',
        aws_secret_access_key => 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY',
        authorization_method  => 'Net::Amazon::S3::Signature::V4',
        secure                => 1,
        use_virtual_host      => 1,
    );
}

sub s3_api_with_signature_2 {
    Net::Amazon::S3->new (
        aws_access_key_id     => 'AKIDEXAMPLE',
        aws_secret_access_key => 'wJalrXUtnFEMI/K7MDENG+bPxRfiCYEXAMPLEKEY',
        authorization_method  => 'Net::Amazon::S3::Signature::V2',
        secure                => 1,
        use_virtual_host      => 1,
    );
}

sub expect_net_amazon_s3_feature {
    my ($title, %params) = @_;

    my $s3 = delete $params{with_s3};
    my $feature = delete $params{feature};
    my $expectation = "expect_$feature";

    local $Test::Builder::Level = $Test::Builder::Level + 1;

    subtest $title => sub {
        plan tests => 2;

        if (my $code = Shared::Examples::Net::Amazon::S3::API->can ($expectation)) {
            $code->( "using S3 API" => (
                with_s3 => $s3,
                %params
            ));
        } else {
            fail "Net::Amazon::S3 feature expectation $expectation not found";
        }

        if (my $code = Shared::Examples::Net::Amazon::S3::Client->can ($expectation)) {
            $code->( "using S3 Client" => (
                with_client => Net::Amazon::S3::Client->new (s3 => $s3),
                %params
            ));
        } else {
            fail "Net::Amazon::S3::Client feature expectation $expectation not found";
        }
    };
}

1;
