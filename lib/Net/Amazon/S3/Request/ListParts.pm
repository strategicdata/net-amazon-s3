package Net::Amazon::S3::Request::ListParts;

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request::Object';

# ABSTRACT: List the parts in a multipart upload.

has 'upload_id'         => ( is => 'ro', isa => 'Str',             required => 1 );
has 'acl_short'         => ( is => 'ro', isa => 'Maybe[AclShort]', required => 0 );
has 'headers' =>
    ( is => 'ro', isa => 'HashRef', required => 0, default => sub { {} } );

__PACKAGE__->meta->make_immutable;

sub _request_query_params {
    my ($self) = @_;

    return ( uploadId => $self->upload_id );
}

sub http_request {
    my $self    = shift;
    my $headers = $self->headers;

    if ( $self->acl_short ) {
        $headers->{'x-amz-acl'} = $self->acl_short;
    }

    return $self->_build_http_request(
        method  => 'GET',
        headers => $self->headers,
    );
}

1;
