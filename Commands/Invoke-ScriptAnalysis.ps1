
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
          #TO DO
        }
    }
    End
    {
    }
}
