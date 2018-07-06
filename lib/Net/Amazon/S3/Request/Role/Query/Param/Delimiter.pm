package Net::Amazon::S3::Request::Role::Query::Param::Delimiter;

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Param' => {
    param => 'delimiter',
    constraint => 'Maybe[Str]',
    required => 0,
};

1;

