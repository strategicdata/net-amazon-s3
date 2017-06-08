requires 'Carp';
requires 'Data::Stream::Bulk::Callback';
requires 'Date::Parse';
requires 'DateTime::Format::HTTP';
requires 'Digest::HMAC_SHA1';
requires 'Digest::MD5';
requires 'Digest::MD5::File';
requires 'Digest::SHA';
requires 'File::Find::Rule';
requires 'File::stat';
requires 'Getopt::Long';
requires 'HTTP::Date';
requires 'HTTP::Status';
requires 'IO::File', '1.14';
requires 'LWP', '6.03';
requires 'LWP::UserAgent::Determined';
requires 'MIME::Base64';
requires 'MIME::Types';
requires 'Moose', '0.85';
requires 'Moose::Util::TypeConstraints';
requires 'MooseX::StrictConstructor', '0.16';
requires 'MooseX::Types::DateTime::MoreCoercions', '0.07';
requires 'POSIX';
requires 'Path::Class';
requires 'Pod::Usage';
requires 'Regexp::Common';
requires 'Term::Encoding';
requires 'Term::ProgressBar::Simple';
requires 'URI';
requires 'URI::Escape';
requires 'URI::QueryParam';
requires 'VM::EC2::Security::CredentialCache';
requires 'XML::LibXML';
requires 'XML::LibXML::XPathContext';
requires 'strict';
requires 'warnings';

on build => sub {
    requires 'File::Temp';
    requires 'LWP::Simple';
    requires 'Test::Exception';
    requires 'Test::More';
    requires 'lib';
    requires 'vars';
};
