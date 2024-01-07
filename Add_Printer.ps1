# ***********************************************************************************************
# Script Name......: Add_Printer.ps1
# Function.........: Add printers from a CSV file filled with printer name, shared printer name, IP or name printer, driver
# Version / Author.: ABA / 1.0 (13/09/2021)
#
# CHANGES :
#
# ***********************************************************************************************

<#
.SYNOPSIS
    .
.DESCRIPTION
    Add printers from a CSV file filled with printer name, shared printer name, IP or name printer, driver

Fields in CSV file need to be separated with a ";", CSV file needs this headers : IP_or_name;Name;Driver;Shared_Name
    This script has be to launched on a print server
.PARAMETER action
    No paramter
.EXAMPLE
    C:\PS>.\Add_Printer.ps1
.NOTES
    Author: ABA
    Date:   13/09/2021
#>

$ImportFile = "C:\Printers.csv"

# Import the printers that are going to be imported

$printers = import-csv $ImportFile -Delimiter ";"

Write-host "Printers creation...Started" -foreground green
foreach ($printer in $printers) {

    # Check if port already exist

    $portname = $printer.IP_or_name

    $checkPortExists = Get-Printerport -Name $portname -ErrorAction SilentlyContinue
    if (-not $checkPortExists) {
        Add-PrinterPort -name $portname -PrinterHostAddress $portname
    }

    # Add the printer

    Add-Printer -Name $printer.Name -DriverName $printer.Driver -PortName $portName -Shared -ShareName $printer.Shared_Name

    write-host "Printer " $printer.Name " added - Port : " $portName " - Driver : " $printer.Driver " - Shared name : " $printer.Shared_Name -foreground Yellow

}

Write-host "Printers creation... Completed" -foreground Green
