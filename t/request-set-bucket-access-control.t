
use strict;
use warnings;

use Test::More tests => 1 + 2;
use Test::Warnings;

use Shared::Examples::Net::Amazon::S3::Request (
    qw[ behaves_like_net_amazon_s3_request ],
);

behaves_like_net_amazon_s3_request 'set bucket access control with header acl' => (
    request_class   => 'Net::Amazon::S3::Request::SetBucketAccessControl',
    with_bucket     => 'some-bucket',
    with_acl_short  => 'private',

    expect_request_method   => 'PUT',
    expect_request_path     => 'some-bucket/?acl',
    expect_request_headers  => { 'x-amz-acl' => 'private' },
);

behaves_like_net_amazon_s3_request 'set bucket access control with body acl' => (
    request_class   => 'Net::Amazon::S3::Request::SetBucketAccessControl',
    with_bucket     => 'some-bucket',
    with_acl_xml    => 'private',

    expect_request_method   => 'PUT',
    expect_request_path     => 'some-bucket/?acl',
    expect_request_headers  => { },
);

