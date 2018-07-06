package Net::Amazon::S3::Request::Role::Query::Action::Acl;

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::Query::Action' => { action => 'acl' };

1;

