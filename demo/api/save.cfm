<cfscript>
	
	// Require the form fields.
	param name="form.clientFilename" type="string";

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //
	
	// This is simply for internal testing so that I could see what would happen when
	// our save-request would fail.
	if ( reFind( "fail", form.clientFilename ) ) {

		throw( type = "App.Forbidden" );

	}

	// ------------------------------------------------------------------------------- //
	// ------------------------------------------------------------------------------- //

	// Create the image record. This does not save the binary file - this only prepares the
	// record that the binary will be associated with. The file will ultimately be uploaded
	// by the client, directly to S3.
	imageID = application.images.addImage( form.clientFilename );

	// Get the new image record.
	image = application.images.getImage( imageID );

	// Prepare API response. Part of the response includes both the image URL and the upload 
	// settings. We are providing the imageUrl; but, the binary won't be available until the
	// upload has completed. The upload settings are tightly coupled to the upload 
	// implementation (Plupload in this case); but, we're just going to pass-through the 
	// settings so that our code is agnostic to the implementation details.
	response.data = {
		"image" = {
			"id" = image.id,
			"clientFilename" = image.clientFilename,
			"fileExtension" = image.fileExtension,
			"mimeType" = image.mimeType,
			"isFileAvailable" = image.isFileAvailable,
			"createdAt" = image.createdAt,
			"updatedAt" = image.updatedAt,
			"imageUrl" = application.storageService.getImageUrl( image )
		},
		"uploadSettings" = application.storageService.getUploadSettings( image )
	};

</cfscript>