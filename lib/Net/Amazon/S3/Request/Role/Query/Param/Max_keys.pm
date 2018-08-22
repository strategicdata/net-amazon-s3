package Net::Amazon::S3::Request::Role::Query::Param::Max_keys;

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Param' => {
    param => 'max_keys',
    query_param => 'max-keys',
    constraint => 'Maybe[Str]',
    required => 0,
    default => 1000,
};

1;

