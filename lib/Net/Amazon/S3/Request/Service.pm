package Net::Amazon::S3::Request::Service;

use Moose 0.85;
use MooseX::StrictConstructor 0.16;
extends 'Net::Amazon::S3::Request';

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Net::Amazon::S3::Request::Service

=head1 DESCRIPTION

Base class for all S3 Service operations

=cut
