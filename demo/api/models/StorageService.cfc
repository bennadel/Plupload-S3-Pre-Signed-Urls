component
	output = false
	hint = "I faciliate storage and access of physical image binaries."
	{

	/**
	* I facilitate storage and access of the physical image binaries associated with the
	* ImageCollection. The images are stored on Amazon S3. 
	* 
	* @aS3Lite I am the S3 gateway.
	* @aAccessID I am the Amazon S3 access ID (need for form settings).
	* @aKeyPrefix I define the sub-path at which S3 objects should be stored.
	* @output false
	*/
	public any function init( 
		required any aS3Lite,
		required string aAccessID,
		required string aKeyPrefix
		) {

		// Store private properties.
		s3Lite = aS3Lite;
		accessID = aAccessID;
		keyPrefix = aKeyPrefix;

		return( this );

	}


	// ---
	// PULIC METHODS.
	// ---


	/**
	* I get the pre-signed S3 url that provides GET access the given Image. The expiration of 
	* the URLs is "bucketed" so that not every request for a URL generates a unique URI. This 
	* will facilitate caching on the client.
	* 
	* @image I am the Image object for which we are getting a URL.
	* @output false
	*/
	public string function getImageUrl( required struct image ){

		// Get the bucketed date for which URL will be valid.
		var nextYear = createDate( ( year( now() ) + 1 ) , 1, 1 );

		// TODO: Implement "response-cache-control" to override the Cache-Control headers
		// of the response. My current S3Lite implementation doesn't afford this.
		return( s3Lite.getPreSignedUrl( "#keyPrefix#/#image.id#.#image.fileExtension#", nextYear ) );

	}


	/**
	* I get the upload settings that will allow the associate image binary to be uploaded 
	* directly from the client up to Amazon S3 without using our server as a proxy.
	* 
	* Returns the following data:
	* - method : String. I am the HTTP method (PUT) to use for the upload.
	* - url : String. The URL of the PUT action.
	* - contentType : String. I am the content-type header used for the upload.
	* - multiPart : Boolean. I am the multipart flag (turned OFF for PUT requests).
	*
	* CAUTION: Since the upload settings are very tightly coupled to the implementation of the
	* upload, it is necessarily very tightly coupled to Plupload and the idiosyncrasies of the 
	* Plupload runtime. This means that we have to remove the generic nature of the concept and 
	* hard-code values that we know Plupload will need to function properly.
	* 
	* @image I am the Image object whose binary is going to be uploaded.
	* @output false
	*/
	public struct function getUploadSettings( required struct image ) {

		// Since this is going to determine how long this upload URL remains valid, we can keep
		// to a fairly short period of time. However, we have to keep in mind that many files 
		// may be dropped in the uploader at one time. As such, this value needs to be short; but
		// it also needs to allow for a delay based on queue position.
		var expiresAt = dateAdd( "h", 1, now() );

		var key = "#keyPrefix#/#image.id#.#image.fileExtension#";
		
		var uploadUrl = s3Lite.getPreSignedUrlForUpload( key, image.mimeType, expiresAt );

		var settings = {
			"method" = "put",
			"url" = uploadUrl,
			"contentType" = image.mimeType,
			"multipart" = false
		};

		return( settings );

	}

}