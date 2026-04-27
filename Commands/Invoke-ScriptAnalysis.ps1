
function Invoke-ScriptAnalysis
{
    [CmdletBinding(SupportsShouldProcess=$true, 
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType([String])]
    Param
    (
       $Text
    )

    Begin
    {
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("script $($Text | select-object -First 5)"))
        {
            Import-Module Az.Accounts 
            connect-AzAccount -Subscription "094200e5-c0b6-4890-aeec-5a21a93a690e" -Identity | Out-Null
            $KeyVaultName="NoShellGames-KV"
            $apiKey=Get-AzKeyVaultSecret -VaultName $KeyVaultName -Name "NoShellGamesAPIKey" -AsPlainText
            $apiUrl = "https://noshellgames.azure-api.net/noshellgames/AnalyzeScript?subscription-key=$apiKey"
            $apiResponse = Invoke-RestMethod -Uri $apiUrl -Body $Text -Method POST
            #$HTMLTemplate=Get-Content $(Join-Path -Path "/usr/local/share/powershell/Modules/NoShellGames-Web/Web" -ChildPath "index.html") -Raw
            #$HTMLResults=[System.Text.StringBuilder]::new()
            $HTMLTemplate=@"
            TEST
"@
            if($apiResponse){
                #$htmlResponse=$HTMLTemplate.Replace('<ResultsTemplate>','TEST')
                $htmlResponse=$HTMLTemplate
            }
          #TO DO
        

          return $htmlResponse
        }
    }
    End
    {
    }
}
