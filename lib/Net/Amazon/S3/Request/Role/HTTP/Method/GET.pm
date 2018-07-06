package Net::Amazon::S3::Request::Role::HTTP::Method::GET;

use Moose::Role;

with 'Net::Amazon::S3::Request::Role::HTTP::Method' => { method => 'GET' };

1;

