# mDomains

mDomains is a PowerShell project that communicates with an API to retrieve WHOIS information for specified domains.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Windows operating system
- PowerShell

### Installation
1. Clone the repository
```bash
git clone https://github.com/medhallal/mDomains.git
```
2. Open PowerShell and navigate to the project directory
```bash
cd mDomains
```

## Usage
The project consists of three main PowerShell scripts:

### mDomains.ps1
This is the main script that checks for domain names with expiration dates within the next day in the local SQLite database and calls `mDomainsStore.ps1` for these domains.

You can run this script manually or schedule it to run automatically using the Windows Task Scheduler.

#### Running the script manually
```bash
powershell.exe -ExecutionPolicy Bypass -File mDomains.ps1
```

#### Scheduling the script to run automatically
1. Open the Task Scheduler (you can search for it in the Start menu).
2. Click on "Create Basic Task...".
3. Name the task (e.g., "mDomains") and provide a description.
4. Choose "Daily" as the trigger.
5. Set the start time according to your preference.
6. Choose "Start a program" as the action.
7. In the "Program/script" field, enter the path to the PowerShell executable (e.g., `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe` or `powershell.exe`).
8. In the "Add arguments (optional)" field, enter the path to the `mDomains.ps1` script (e.g., `C:\mDomains\mDomains.ps1`).

   Note: Some versions of Windows may require you to add the `-ExecutionPolicy Bypass` flag to the "Add arguments (optional)" field.
   So the "Add arguments (optional)" field would look like this: `-ExecutionPolicy Bypass C:\mDomains\mDomains.ps1`

9. Click "Finish" to create the task.


### mDomainsStore.ps1
This script communicates with the WHOIS API to retrieve information about the specified domains and stores the response in a local SQLite database.  
If the domain is set to expire within the next day, it calls `mDomainsNotify.ps1` to display a message box.  
You can run this script manually to add a domain to the database or to update the information of an existing domain.
```bash
powershell.exe -ExecutionPolicy Bypass -File mDomainsStore.ps1 -domain_names <domain_name>
```
Replace `<domain_name>` with the domain name you want to add or update.  
Note: You can specify multiple domains by separating them with a comma (e.g., `example.com,example.org`).

To get the WHOIS information for a domain you need to provide an API key. You can get a free API key by signing up at [whoisxmlapi.com](https://whoisxmlapi.com/). or any other WHOIS API provider.  
For this project, I used [apilayer.com](https://apilayer.com/marketplace/whois-api).

Don't forget to replace `<api_url>` with your actual API URL and `<api_key>` with your API key in the `mDomainsStore.ps1` script.

Note that each API provider has its own response format, so you may need to modify the script to parse the response correctly.



### mDomainsNotify.ps1
This script is used to display a message box with a specified message and domain name. If the user clicks 'OK', it opens the WHOIS information of the domain in the default web browser.


## Help

If you encounter any problems or have any questions about this script, please open an issue in this repository.

## Authors

Contributors names and contact info

* [medhallal](https://github.com/medhallal)

## Version History

* 0.1
    * Initial Release


## License

This project is licensed under the [MIT License](LICENSE).

[//]: # (## Acknowledgments)

[//]: # (Inspiration, code snippets, etc.)

## How to Contribute

I welcome contributions from the community. Here are a few ways you can help:

* Add functionality: If you have a feature in mind, feel free to create an issue and discuss it. Once approved, you can fork the repository, make your changes, and submit a pull request.
* Improve documentation: If you notice any errors or room for improvement in the documentation, please update it and submit a pull request.
* Report bugs: If you find a bug, please create an issue detailing the problem and how to reproduce it. If you can fix the bug yourself, you can also submit a pull request with the fix.
