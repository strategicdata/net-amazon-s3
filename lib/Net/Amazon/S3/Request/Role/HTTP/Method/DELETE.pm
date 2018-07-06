package Net::Amazon::S3::Request::Role::HTTP::Method::DELETE;

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::HTTP::Method' => { method => 'DELETE' };

1;

