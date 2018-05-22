
use strict;
use warnings;

package Net::Amazon::S3::Signature::V4;

use Moose;

use Net::Amazon::S3::Signature::V4Implementation;
use Digest::SHA;
use Ref::Util;

use namespace::clean;

extends 'Net::Amazon::S3::Signature';

sub _bucket_region {
    my ($self) = @_;

    return unless $self->http_request->bucket;
    return $self->http_request->bucket->region;
}

sub _sign {
    my ($self) = @_;

    return Net::Amazon::S3::Signature::V4Implementation->new(
        $self->http_request->s3->aws_access_key_id,
        $self->http_request->s3->aws_secret_access_key,
        $self->_bucket_region,
        's3',
    );
}

sub sign_request {
    my ($self, $request) = @_;

    my $sha = Digest::SHA->new( '256' );
    if (Ref::Util::is_coderef( my $coderef = $request->content )) {
        while (length (my $snippet = $coderef->())) {
            $sha->add ($snippet);
        }

        $request->header( $Net::Amazon::S3::Signature::V4Implementation::X_AMZ_CONTENT_SHA256 => $sha->hexdigest );
    }


    $self->_sign->sign( $request );

    return $request;
}

sub sign_uri {
    my ($self, $request, $expires_at) = @_;

    return $self->_sign->sign_uri( $request->uri, $expires_at - time );
}

1;
