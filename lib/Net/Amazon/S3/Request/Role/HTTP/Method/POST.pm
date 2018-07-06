package Net::Amazon::S3::Request::Role::HTTP::Method::POST;

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::HTTP::Method' => { method => 'POST' };

1;

