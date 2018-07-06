package Net::Amazon::S3::Request::ListBucket;

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
use URI::Escape qw(uri_escape_utf8);
extends 'Net::Amazon::S3::Request::Bucket';

# ABSTRACT: An internal class to list a bucket

with 'Net::Amazon::S3::Request::Role::Query::Param::Delimiter';
with 'Net::Amazon::S3::Request::Role::Query::Param::Marker';
with 'Net::Amazon::S3::Request::Role::Query::Param::Max_keys';
with 'Net::Amazon::S3::Request::Role::Query::Param::Prefix';

__PACKAGE__->meta->make_immutable;

sub http_request {
    my $self = shift;

    return $self->_build_http_request(
        method => 'GET',
    );
}

1;

__END__

=for test_synopsis
no strict 'vars'

=head1 SYNOPSIS

  my $http_request = Net::Amazon::S3::Request::ListBucket->new(
    s3        => $s3,
    bucket    => $bucket,
    delimiter => $delimiter,
    max_keys  => $max_keys,
    marker    => $marker,
  )->http_request;

=head1 DESCRIPTION

This module lists a bucket.

=head1 METHODS

=head2 http_request

This method returns a HTTP::Request object.

