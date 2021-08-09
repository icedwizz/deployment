#[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Setup all the input variables
[CmdletBinding()]
param (
    $apiKey,
	$inputFolder,
	$serverBase,
	$dataLocation,
	$modelName
)

$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("API-Key", "$apiKey")

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

#########################################################################################
#
#                            FIND THE MODEL TO IMPORT
#
#########################################################################################

# Get the file to load in 
#https://stackoverflow.com/questions/32817654/finding-a-file-that-has-highest-number-in-the-filename-using-powershell
$inputFile = Get-ChildItem -Path $inputFolder | Sort-Object { [regex]::Replace($_.Name, '\d+', { $args[0].Value.PadLeft(20) }) } | select -Last 1

# Save that model edition
$modelEdition = [regex]::match($inputFile, "\[(.*)\]").Groups[1].Value
echo "modelEdition= $modelEdition"

# Produce the actual filename to load
$inputFile="$inputFolder\$inputFile"
$inputFile = $inputFile.replace("[", "``[")
$inputFile = $inputFile.replace("]", "``]")
echo "inputFile= $inputFile"




#########################################################################################
#
#                            IMPORT THE MODEL
#
#########################################################################################

# Update the API endpoint
$importAPI="/api/rest/app-builder/model-imports"
$importURL="$serverBase$importAPI"


# Import the exported model to Semarchy
echo "Importing open model to Semarchy"
echo $importURL

$response = Invoke-WebRequest -Uri $importURL -Method "POST" -Headers $headers -InFile $inputFile -ContentType "application/octet-stream" -UseBasicParsing
$status = $response.StatusCode
echo "Import of model response: $status"

#########################################################################################
#
#                            DEPLOY THE MODEL
#
#########################################################################################


# Update the API endpoint
$deployAPI="/api/rest/app-builder/data-locations/$dataLocation/deploy"
$deployURL="$serverBase$deployAPI"

# Set the body of the message
$deployBody=@{
	"modelName"="$modelName";
	"modelEditionKey"="$modelEdition";
}

# Deploy the newly imported model to the data location
echo "Deploying model URL"
echo $deployAPI

$response = Invoke-WebRequest -Uri $deployURL -Method "POST" -Headers $headers -ContentType "application/json" -Body ($deployBody|ConvertTo-Json) -UseBasicParsing
$status = $response.StatusCode
echo "Deployment response: $status"

