
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
            $HTMLTemplate=Get-Content $(Join-Path -Path "/usr/local/share/powershell/Modules/Web" -ChildPath "index.html") -Raw
          #TO DO
          <#
                      <div class="result-header">
            <div>
                <p class="result-label">Risk Score</p>
                <h2 id="riskScore" class="risk-score">82</h2>
            </div>
            <div class="risk-badge high" id="riskLevel">HIGH</div>
        </div>

        <div class="result-section">
            <h3>Top Findings</h3>
            <ul id="findingsList" class="findings-list">
                <li>Invoke-Expression detected — dynamic code execution risk</li>
                <li>Web request usage detected — potential remote payload</li>
                <li>Base64 decoding detected — possible obfuscation</li>
            </ul>
        </div>

        <div class="result-section">
            <h3>Recommendation</h3>
            <p id="recommendationText" class="recommendation danger">
                Do NOT run on production endpoints
            </p>
        </div>
          #>
        }
    }
    End
    {
    }
}
