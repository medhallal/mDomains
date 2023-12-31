param (
    [Parameter(Mandatory=$true)]
    [string]$domain_names
)

Add-Type -Path "$PSScriptRoot\System.Data.SQLite.dll"
$apikey = "<api_key>"
$apiUrl = "<api_url>"
$domain_names = $domain_names.ToLower()

# Store the response in a local SQLite database
$database_name = "$PSScriptRoot\mDomains.db"
$table_name = "domains"

$headers = @{
    "Content-Type" = "text/plain"
    "apikey" = $apikey
}

if (-not (Test-Path $database_name)) {
    New-Item -ItemType File -Path $database_name
}

$connection_string = "Data Source=$database_name;Version=3;"
$connection = New-Object System.Data.SQLite.SQLiteConnection
$connection.ConnectionString = $connection_string
$connection.Open()

$command = $connection.CreateCommand()
$command.CommandText = "CREATE TABLE IF NOT EXISTS $table_name (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, domain_name VARCHAR(253) NOT NULL, creation_date DATETIME DEFAULT NULL, updated_date DATETIME DEFAULT NULL, expiration_date DATETIME DEFAULT NULL, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT NULL)"
$command.ExecuteNonQuery()

$domain_names.Split(",") | ForEach-Object {
    $domain_name = $_
    $url = $apiUrl+$domain_name

    try {
        $response = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
    } catch {
        & "$PSScriptRoot\mDomainsNotify.ps1" -domain_name $domain_name -message $_.Exception.Response.StatusCode
        if($_.Exception.Response.StatusCode -eq 'NotFound'){
            $json = '{"result":{"creation_date":null,"updated_date":null,"expiration_date":null,"domain_name":"'+$domain_name+'"}}'
            $response = ConvertFrom-Json $json
        } else {
            return
        }
    }

    if(-not [string]::IsNullOrWhiteSpace($response.result.expiration_date)){
        if([DateTime]::ParseExact($response.result.expiration_date, "yyyy-MM-dd HH:mm:ss", $null) -lt (Get-Date).AddDays(1)){
            & "$PSScriptRoot\mDomainsNotify.ps1" -domain_name $domain_name -message "This web address is fading fast, like a fleeting sunset. Less than 24 hours remain to revive it, so seize the moment or let it gracefully bow out of existence..."
        }
    } else {
        Read-Host -Prompt "Press Enter to exit"
        return
    }

    $command.CommandText = "UPDATE $table_name SET creation_date='$($response.result.creation_date)', updated_date='$($response.result.updated_date)', expiration_date='$($response.result.expiration_date)', updated_at=CURRENT_TIMESTAMP WHERE domain_name='$($response.result.domain_name)'"
    $command.ExecuteNonQuery()

    $command.CommandText = "SELECT changes()"
    $affected_rows = $command.ExecuteScalar()

    if ($affected_rows -eq 0) {
        $command.CommandText = "INSERT INTO $table_name (domain_name, creation_date, updated_date, expiration_date) VALUES ('$($response.result.domain_name)', '$($response.result.creation_date)', '$($response.result.updated_date)', '$($response.result.expiration_date)')"
        $command.ExecuteNonQuery()
    }
}

$connection.Close()

