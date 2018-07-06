package Net::Amazon::S3::Request::Role::HTTP::Header::Encryption;

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::HTTP::Header' => {
    name => 'encryption',
    header => 'x-amz-server-side-encryption',
    isa => 'Maybe[Str]',
    required => 0,
};

1;
