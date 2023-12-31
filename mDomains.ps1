Add-Type -Path "$PSScriptRoot\System.Data.SQLite.dll"

$database_name = "$PSScriptRoot\mDomains.db"
$table_name = "domains"

$connection_string = "Data Source=$database_name;Version=3;"
$connection = New-Object System.Data.SQLite.SQLiteConnection
$connection.ConnectionString = $connection_string
$connection.Open()

$command = $connection.CreateCommand()
$command.CommandText = "CREATE TABLE IF NOT EXISTS $table_name (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, domain_name VARCHAR(253) NOT NULL, creation_date DATETIME DEFAULT NULL, updated_date DATETIME DEFAULT NULL, expiration_date DATETIME DEFAULT NULL, created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP NULL DEFAULT NULL)"
$command.ExecuteNonQuery()


$command.CommandText = "SELECT domain_name FROM $table_name WHERE expiration_date < datetime('now', '+1 day')"
$result = $command.ExecuteReader()
$domain_names = @()
while ($result.Read()) {
    $domain_names += $result.GetString(0)
}
if ($domain_names) {
    $expired_domains = $domain_names -join ","
    $connection.Close()
    if(-not [string]::IsNullOrWhiteSpace($expired_domains)){
        . "$PSScriptRoot\mDomainsStore.ps1" -domain_names $expired_domains
    }
} else {
    $connection.Close()
}

