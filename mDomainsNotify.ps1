param (
    [Parameter(Mandatory=$true)]
    [string]$domain_name,
    [Parameter(Mandatory=$true)]
    [string]$message
)

Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::OKCancel
$MessageboxTitle = "mDomains - $domain_name"
$Messageboxbody = "Error: $message`n`nClick on OK to check the Whois information of $domain_name`nClick on Cancel to ignore this."
$MessageIcon = [System.Windows.MessageBoxImage]::Warning
$response = [System.Windows.MessageBox]::Show($Messageboxbody,$MessageboxTitle,$ButtonType,$messageicon)
if ($response -eq 'OK'){
    Start-Process "https://www.whois.com/whois/$domain_name"
}
