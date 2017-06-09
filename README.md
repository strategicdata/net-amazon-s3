# SYNOPSIS

    use Net::Amazon::S3;
    my $aws_access_key_id     = 'fill me in';
    my $aws_secret_access_key = 'fill me in too';

    my $s3 = Net::Amazon::S3->new(
        {   aws_access_key_id     => $aws_access_key_id,
            aws_secret_access_key => $aws_secret_access_key,
            # or use an IAM role.
            use_iam_role          => 1

            retry                 => 1,
        }
    );

    # a bucket is a globally-unique directory
    # list all buckets that i own
    my $response = $s3->buckets;
    foreach my $bucket ( @{ $response->{buckets} } ) {
        print "You have a bucket: " . $bucket->bucket . "\n";
    }

    # create a new bucket
    my $bucketname = 'acmes_photo_backups';
    my $bucket = $s3->add_bucket( { bucket => $bucketname } )
        or die $s3->err . ": " . $s3->errstr;

    # or use an existing bucket
    $bucket = $s3->bucket($bucketname);

    # store a file in the bucket
    $bucket->add_key_filename( '1.JPG', 'DSC06256.JPG',
        { content_type => 'image/jpeg', },
    ) or die $s3->err . ": " . $s3->errstr;

    # store a value in the bucket
    $bucket->add_key( 'reminder.txt', 'this is where my photos are backed up' )
        or die $s3->err . ": " . $s3->errstr;

    # list files in the bucket
    $response = $bucket->list_all
        or die $s3->err . ": " . $s3->errstr;
    foreach my $key ( @{ $response->{keys} } ) {
        my $key_name = $key->{key};
        my $key_size = $key->{size};
        print "Bucket contains key '$key_name' of size $key_size\n";
    }

    # fetch file from the bucket
    $response = $bucket->get_key_filename( '1.JPG', 'GET', 'backup.jpg' )
        or die $s3->err . ": " . $s3->errstr;

    # fetch value from the bucket
    $response = $bucket->get_key('reminder.txt')
        or die $s3->err . ": " . $s3->errstr;
    print "reminder.txt:\n";
    print "  content length: " . $response->{content_length} . "\n";
    print "    content type: " . $response->{content_type} . "\n";
    print "            etag: " . $response->{content_type} . "\n";
    print "         content: " . $response->{value} . "\n";

    # delete keys
    $bucket->delete_key('reminder.txt') or die $s3->err . ": " . $s3->errstr;
    $bucket->delete_key('1.JPG')        or die $s3->err . ": " . $s3->errstr;

    # and finally delete the bucket
    $bucket->delete_bucket or die $s3->err . ": " . $s3->errstr;

# DESCRIPTION

This module provides a Perlish interface to Amazon S3. From the
developer blurb: "Amazon S3 is storage for the Internet. It is
designed to make web-scale computing easier for developers. Amazon S3
provides a simple web services interface that can be used to store and
retrieve any amount of data, at any time, from anywhere on the web. It
gives any developer access to the same highly scalable, reliable,
fast, inexpensive data storage infrastructure that Amazon uses to run
its own global network of web sites. The service aims to maximize
benefits of scale and to pass those benefits on to developers".

To find out more about S3, please visit: http://s3.amazonaws.com/

To use this module you will need to sign up to Amazon Web Services and
provide an "Access Key ID" and " Secret Access Key". If you use this
module, you will incurr costs as specified by Amazon. Please check the
costs. If you use this module with your Access Key ID and Secret
Access Key you must be responsible for these costs.

I highly recommend reading all about S3, but in a nutshell data is
stored in values. Values are referenced by keys, and keys are stored
in buckets. Bucket names are global.

Note: This is the legacy interface, please check out
[Net::Amazon::S3::Client](https://metacpan.org/pod/Net::Amazon::S3::Client) instead.

Development of this code happens here: https://github.com/rustyconover/net-amazon-s3

# METHODS

## new

Create a new S3 client object. Takes some arguments:

- aws\_access\_key\_id

    Use your Access Key ID as the value of the AWSAccessKeyId parameter
    in requests you send to Amazon Web Services (when required). Your
    Access Key ID identifies you as the party responsible for the
    request.

- aws\_secret\_access\_key

    Since your Access Key ID is not encrypted in requests to AWS, it
    could be discovered and used by anyone. Services that are not free
    require you to provide additional information, a request signature,
    to verify that a request containing your unique Access Key ID could
    only have come from you.

    DO NOT INCLUDE THIS IN SCRIPTS OR APPLICATIONS YOU DISTRIBUTE. YOU'LL BE SORRY

- aws\_session\_token

    If you are using temporary credentials provided by the AWS Security Token
    Service, set the token here, and it will be added to the request in order to
    authenticate it.

- use\_iam\_role

    If you'd like to use IAM provided temporary credentials, pass this option
    with a true value.

- secure

    Set this to `1` if you want to use SSL-encrypted connections when talking
    to S3. Defaults to `0`.

    To use SSL-encrypted connections, LWP::Protocol::https is required.

- timeout

    How many seconds should your script wait before bailing on a request to S3? Defaults
    to 30.

- retry

    If this library should retry upon errors. This option is recommended.
    This uses exponential backoff with retries after 1, 2, 4, 8, 16, 32 seconds,
    as recommended by Amazon. Defaults to off.

- host

    The S3 host endpoint to use. Defaults to 's3.amazonaws.com'. This allows
    you to connect to any S3-compatible host.

- use\_virtual\_host

    Use the virtual host method ('bucketname.s3.amazonaws.com') instead of specifying the
    bucket at the first part of the path. This is particularily useful if you want to access
    buckets not located in the US-Standard region (such as EU, Asia Pacific or South America).
    See [http://docs.aws.amazon.com/AmazonS3/latest/dev/VirtualHosting.html](http://docs.aws.amazon.com/AmazonS3/latest/dev/VirtualHosting.html) for the pros and cons.

### Notes

When using [Net::Amazon::S3](https://metacpan.org/pod/Net::Amazon::S3) in child processes using fork (such as in
combination with the excellent [Parallel::ForkManager](https://metacpan.org/pod/Parallel::ForkManager)) you should create the
S3 object in each child, use a fresh LWP::UserAgent in each child, or disable
the [LWP::ConnCache](https://metacpan.org/pod/LWP::ConnCache) in the parent:

    $s3->ua( LWP::UserAgent->new( 
        keep_alive => 0, requests_redirectable => [qw'GET HEAD DELETE PUT POST'] );

## buckets

Returns undef on error, else hashref of results

## add\_bucket

Takes a hashref:

- bucket

    The name of the bucket you want to add

- acl\_short (optional)

    See the set\_acl subroutine for documenation on the acl\_short options

- location\_constraint (option)

    Sets the location constraint of the new bucket. If left unspecified, the
    default S3 datacenter location will be used. Otherwise, you can set it
    to 'EU' for a European data center - note that costs are different.

Returns 0 on failure, Net::Amazon::S3::Bucket object on success

## bucket BUCKET

Takes a scalar argument, the name of the bucket you're creating

Returns an (unverified) bucket object from an account. Does no network access.

## delete\_bucket

Takes either a [Net::Amazon::S3::Bucket](https://metacpan.org/pod/Net::Amazon::S3::Bucket) object or a hashref containing

- bucket

    The name of the bucket to remove

Returns false (and fails) if the bucket isn't empty.

Returns true if the bucket is successfully deleted.

## list\_bucket

List all keys in this bucket.

Takes a hashref of arguments:

MANDATORY

- bucket

    The name of the bucket you want to list keys on

OPTIONAL

- prefix

    Restricts the response to only contain results that begin with the
    specified prefix. If you omit this optional argument, the value of
    prefix for your query will be the empty string. In other words, the
    results will be not be restricted by prefix.

- delimiter

    If this optional, Unicode string parameter is included with your
    request, then keys that contain the same string between the prefix
    and the first occurrence of the delimiter will be rolled up into a
    single result element in the CommonPrefixes collection. These
    rolled-up keys are not returned elsewhere in the response.  For
    example, with prefix="USA/" and delimiter="/", the matching keys
    "USA/Oregon/Salem" and "USA/Oregon/Portland" would be summarized
    in the response as a single "USA/Oregon" element in the CommonPrefixes
    collection. If an otherwise matching key does not contain the
    delimiter after the prefix, it appears in the Contents collection.

    Each element in the CommonPrefixes collection counts as one against
    the MaxKeys limit. The rolled-up keys represented by each CommonPrefixes
    element do not.  If the Delimiter parameter is not present in your
    request, keys in the result set will not be rolled-up and neither
    the CommonPrefixes collection nor the NextMarker element will be
    present in the response.

- max-keys

    This optional argument limits the number of results returned in
    response to your query. Amazon S3 will return no more than this
    number of results, but possibly less. Even if max-keys is not
    specified, Amazon S3 will limit the number of results in the response.
    Check the IsTruncated flag to see if your results are incomplete.
    If so, use the Marker parameter to request the next page of results.
    For the purpose of counting max-keys, a 'result' is either a key
    in the 'Contents' collection, or a delimited prefix in the
    'CommonPrefixes' collection. So for delimiter requests, max-keys
    limits the total number of list results, not just the number of
    keys.

- marker

    This optional parameter enables pagination of large result sets.
    `marker` specifies where in the result set to resume listing. It
    restricts the response to only contain results that occur alphabetically
    after the value of marker. To retrieve the next page of results,
    use the last key from the current page of results as the marker in
    your next request.

    See also `next_marker`, below.

    If `marker` is omitted,the first page of results is returned.

Returns undef on error and a hashref of data on success:

The hashref looks like this:

    {
          bucket          => $bucket_name,
          prefix          => $bucket_prefix,
          common_prefixes => [$prefix1,$prefix2,...]
          marker          => $bucket_marker,
          next_marker     => $bucket_next_available_marker,
          max_keys        => $bucket_max_keys,
          is_truncated    => $bucket_is_truncated_boolean
          keys            => [$key1,$key2,...]
     }

Explanation of bits of that:

- common\_prefixes

    If list\_bucket was requested with a delimiter, common\_prefixes will
    contain a list of prefixes matching that delimiter.  Drill down into
    these prefixes by making another request with the prefix parameter.

- is\_truncated

    B flag that indicates whether or not all results of your query were
    returned in this response. If your results were truncated, you can
    make a follow-up paginated request using the Marker parameter to
    retrieve the rest of the results.

- next\_marker

    A convenience element, useful when paginating with delimiters. The
    value of `next_marker`, if present, is the largest (alphabetically)
    of all key names and all CommonPrefixes prefixes in the response.
    If the `is_truncated` flag is set, request the next page of results
    by setting `marker` to the value of `next_marker`. This element
    is only present in the response if the `delimiter` parameter was
    sent with the request.

Each key is a hashref that looks like this:

     {
        key           => $key,
        last_modified => $last_mod_date,
        etag          => $etag, # An MD5 sum of the stored content.
        size          => $size, # Bytes
        storage_class => $storage_class # Doc?
        owner_id      => $owner_id,
        owner_displayname => $owner_name
    }

## list\_bucket\_all

List all keys in this bucket without having to worry about
'marker'. This is a convenience method, but may make multiple requests
to S3 under the hood.

Takes the same arguments as list\_bucket.

## add\_key

DEPRECATED. DO NOT USE

## get\_key

DEPRECATED. DO NOT USE

## head\_key

DEPRECATED. DO NOT USE

## delete\_key

DEPRECATED. DO NOT USE

# LICENSE

This module contains code modified from Amazon that contains the
following notice:

    #  This software code is made available "AS IS" without warranties of any
    #  kind.  You may copy, display, modify and redistribute the software
    #  code either by itself or as incorporated into your code; provided that
    #  you do not remove any proprietary notices.  Your use of this software
    #  code is at your own risk and you waive any claim against Amazon
    #  Digital Services, Inc. or its affiliates with respect to your use of
    #  this software code. (c) 2006 Amazon Digital Services, Inc. or its
    #  affiliates.

# TESTING

Testing S3 is a tricky thing. Amazon wants to charge you a bit of
money each time you use their service. And yes, testing counts as using.
Because of this, the application's test suite skips anything approaching
a real test unless you set these three environment variables:

- AMAZON\_S3\_EXPENSIVE\_TESTS

    Doesn't matter what you set it to. Just has to be set

- AWS\_ACCESS\_KEY\_ID

    Your AWS access key

- AWS\_ACCESS\_KEY\_SECRET

    Your AWS sekkr1t passkey. Be forewarned that setting this environment variable
    on a shared system might leak that information to another user. Be careful.

# AUTHOR

Leon Brocard <acme@astray.com> and unknown Amazon Digital Services programmers.

Brad Fitzpatrick <brad@danga.com> - return values, Bucket object

Pedro Figueiredo <me@pedrofigueiredo.org> - since 0.54

# SEE ALSO

[Net::Amazon::S3::Bucket](https://metacpan.org/pod/Net::Amazon::S3::Bucket)
