package Net::Amazon::S3::Request::Role::Query::Param::Prefix;

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Param' => {
    param => 'prefix',
    constraint => 'Maybe[Str]',
    required => 0,
};

1;

