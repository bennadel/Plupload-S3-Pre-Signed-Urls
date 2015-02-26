
# Using Plupload To Upload Files Directly To Amazon S3 Using PUT And Pre-Signed URLs

by [Ben Nadel][bennadel] (on [Google+][googleplus])

Out of the box, Plupload is hard-coded to use the POST method when uploading files. This 
is great, unless you want to upload files directly to Amazon S3 using pre-signed, query-
string authenticated URLs. In that case, you have to use the PUT method. This project is
a proof-of-concept that the Plupload library can be patched in order to make the HTTP 
verb and the Content-Type header parameterizable so that they can be more dynamic.

[bennadel]: http://www.bennadel.com
[googleplus]: https://plus.google.com/108976367067760160494?rel=author
[plupload]: http://plupload.com
[angularjs]: http://angularjs.org
