function Invoke-XMLTransform {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$XMLFile,
        [Parameter(Mandatory)]
        [string]$XMLXsl,
        [Parameter(Mandatory)]
        [string]$OutputFile
    )
    $xslsettings = New-Object System.Xml.Xsl.XsltSettings;
    $Xmlurlresolver = New-Object System.Xml.XmlUrlResolver;
    $xslsettings.EnableScript = 1;
    $xslt = New-Object System.Xml.Xsl.XslCompiledTransform;
    $xslt.Load($XMLXsl, $xslsettings, $XmlUrlResolver);
    $xslt.Transform($XMLFile, $OutputFile);
}

Clear-Host
Invoke-XMLTransform input.xml input.xsl output.txt