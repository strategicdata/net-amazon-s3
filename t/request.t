
use strict;
use warnings;

use Test::More tests => 1 + 11;
use Test::Warnings;

use Moose::Meta::Class;

use Net::Amazon::S3;

use Shared::Examples::Net::Amazon::S3::Request (
    qw[ expect_request_class ],
    qw[ expect_request_instance ],
);

my $request_class;

sub request_class {
    ($request_class) = @_;

    expect_request_class $request_class;
}

sub request_path {
    my ($title, %params) = @_;

    my $request = expect_request_instance
        request_class => $request_class,
        roles => [ 'Net::Amazon::S3::Role::Bucket' ],
        with_bucket => $params{with_bucket},
        ;

    my $request_path = $request->_build_signed_request (
        method => 'GET',
        path => $request->_uri (($params{with_key}) x exists $params{with_key}),
    )->path;

    is
        $request_path,
        $params{expect},
        $title,
        ;
}

request_class 'Net::Amazon::S3::Request';

request_path 'bucket request',
    with_bucket => 'some-bucket',
    expect      => 'some-bucket/',
    ;

request_path 'object request with empty key',
    with_bucket => 'some-bucket',
    with_key    => '',
    expect      => 'some-bucket/',
    ;

request_path 'object request should recognize leading slash',
    with_bucket => 'some-bucket',
    with_key    => '/some/key',
    expect      => 'some-bucket/some/key',
    ;

request_path 'object request should sanitize key with slash sequences',
    with_bucket => 'some-bucket',
    with_key    => '//some///key',
    expect      =>'some-bucket/some/key',
    ;

request_path 'object request should uri-escape key',
    with_bucket => 'some-bucket',
    with_key    => 'some/ %/key',
    expect      => 'some-bucket/some/%20%25/key',
    ;

