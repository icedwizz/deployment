#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
 
# Setup all the input variables
[CmdletBinding()]
param (
    $apiKey,
	$serverBase,
	$modelName,
	$devModelEdition,
	$outputFolderLocation,
	$releaseDescription
)


 
###################################################################################################
#
#                            SETUP VARIABLE
#
###################################################################################################
 
# Create all the working variables the rest of the script uses
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("API-Key", "$apiKey")
$openModelFile="$outputFolderLocation\$modelName `[$devModelEdition`].xml"
$description=@{description="$releaseDescription"}
$temp="temp.xml"
 
 
#########################################################################################
#
#                            CHECK SEMARCHY VERSION
#
#########################################################################################

#ping azdev-smdmweb01

# Update the API endpoint
$versionAPI="/api/rest/admin/version"
$versionURL="$serverBase$versionAPI"

# Get the version
echo "Version API endpoint"
echo $versionURL

$response = Invoke-WebRequest -Uri $versionURL -Method "GET" -Headers $headers -UseBasicParsing
$status = $response.StatusCode
echo "Version response: $status"




###################################################################################################
#
#                            PERFORM THE EXPORT OF THE CURRENT MODEL
#
###################################################################################################
 
$exportAPI="/api/rest/app-builder/models/$modelName/editions/$devModelEdition/content"
$exportURL="$serverBase$exportAPI"
 
# Perform the export
echo "Exporting open model"
$response = Invoke-WebRequest -Uri $exportURL -Headers $headers -OutFile $temp -UseBasicParsing
$status = $response.StatusCode
echo "Export response: $status"
 
# Format the XML file to be loaded
echo "Prettifying XML export"
$x = [xml](Get-Content .\$temp)
$x.Save($openModelFile)
 
 
 
 
###################################################################################################
#
#                            FIND THE MODEL TO IMPORT OVER
#
###################################################################################################
 
$modelAPI="/api/rest/app-builder/models/$modelName/editions"
$modelURL="$serverBase$modelAPI"
$releaseModelKey=""
 
# Find the model edition to override
echo "Retrieving model to override"
$response = Invoke-WebRequest -Uri $modelURL -Headers $headers -UseBasicParsing
# Convert the response to JSON
$json = $response.Content | ConvertFrom-Json
 
# Find the maximum key.  This will always be the one we want to release into (or at least it should be close)
$releaseModelKey=$json.key | sort {[version] $_} | Select-Object -Last 1
echo "Model to override is $releaseModelKey"
 
 
 
 
###################################################################################################
#
#                            IMPORT THE MODEL TO THE RELEASE BRANCH
#
###################################################################################################
 
# Update the API endpoin
$importAPI="/api/rest/app-builder/models/$modelName/editions/$releaseModelKey/content"
$importURL="$serverBase$importAPI"
 
# Import the exported model to the release branch in Semarchy
echo "Importing open model to release branch"
$response = Invoke-WebRequest -Uri $importURL -Method "POST" -Headers $headers -InFile $temp -ContentType "application/octet-stream" -UseBasicParsing
$status = $response.StatusCode
echo "Import of model response: $status"
 
 
 
 
 
 
###################################################################################################
#
#                            CLOSE THE RELEASE BRANCH
#
###################################################################################################
 
$closeAPI="/api/rest/app-builder/models/$modelName/editions/$releaseModelKey/close"
$closeURL="$serverBase$closeAPI"
 
# Close the newly imported release
echo "Closing release model"
$response = Invoke-WebRequest -Uri $closeURL -Method "POST" -Headers $headers -Body ($description|ConvertTo-Json) -ContentType "application/json" -UseBasicParsing
$status = $response.StatusCode
echo "Import of model response: $status"
 
 
 
 
 
 
 
###################################################################################################
#
#                            EXPORT THE CLOSED RELEASE BRANCH
#
###################################################################################################
 
$exportReleaseAPI="/api/rest/app-builder/models/$modelName/editions/$releaseModelKey/content"
$exportReleaseURL="$serverBase$exportReleaseAPI"
$closedModelFile="$outputFolderLocation\$modelName `[$releaseModelKey`].xml"
 
# Export the newly closed release branch
echo "Export release model"
$response = Invoke-WebRequest -Uri $exportReleaseURL -Headers $headers -OutFile $temp -UseBasicParsing
$status = $response.StatusCode
echo "Export of release model response: $status"

# Format the XML file to be loaded
echo "Prettifying XML export"
$x = [xml](Get-Content .\$temp)
$x.Save($closedModelFile)
 
# Remove the temp files
echo "Cleaning up temp files"
rm $temp