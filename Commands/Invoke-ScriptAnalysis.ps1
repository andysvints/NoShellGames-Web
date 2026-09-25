
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
            $apiUrl = "https://noshellgames.azure-api.net/noshellgames/Analyze-Script?subscription-key=$apiKey"
            $apiResponse = Invoke-RestMethod -Uri $apiUrl -Body $Text -Method POST
            #$HTMLTemplate=Get-Content $(Join-Path -Path "/usr/local/share/powershell/Modules/NoShellGames-Web/Web" -ChildPath "index.html") -Raw
            #$HTMLResults=[System.Text.StringBuilder]::new()
            $HTMLTemplate=@"
             <div class="result-header">
            <div>
                <p class="result-label">Risk Score</p>
                <h2 id="riskScore" class="risk-score"><RiskScore></h2>
            </div>
            <div class="risk-badge <RiskLevel>" id="riskLevel"><RiskLevel></div>
        </div>
        <Recommendation>
        <AssessmentStats>
        <Findings>
    </div>
    </div><div id="resultCard" class="result-card"> 
         <p class="info-note"> Free checks are limited. Need higher limits, report export or API access?</p>
         <a class="early-access-link" href="https://mailchi.mp/bccc5d23d447/nsg-earlyaccess" target="_blank" rel="noopener noreferrer">
               Request Early Access
          </a>
"@
            if($apiResponse){
                $htmlResponse=$HTMLTemplate.Replace('<RiskScore>',$apiResponse.scoring.score)
                $htmlResponse=$htmlResponse.Replace('<RiskLevel>',$apiResponse.scoring.risk)
                if($apiResponse.assessment){
                    $AssessmentStats=@"
                    <div class="result-stats">

"@
                    foreach($s in @(
                                        @{ Name = 'Findings'; Value = $apiResponse.assessment.uniqueFindingCount },
                                        @{ Name = 'Behaviors'; Value = $apiResponse.assessment.behaviorCount },
                                        @{ Name = 'Capabilities'; Value = $apiResponse.assessment.capabilityCount }
                                    )){
                          $AssessmentStats+=$("<div class=`"result-stat`"><strong>$($s.Value)</strong><span>$($s.Name)</span></div>")
                    }
                $AssessmentStats+="</div>"
                }
                if($apiResponse.findings){
                    $Findings=@"
                    <div class="result-section">
            <h3>Security Findings</h3>
            <ul id="findingsList" class="findings-list">          
"@
                    foreach($f in $apiResponse.findings){
                        $Findings+="<li>"+$($f.description)+"</li>"
                    }
                    $TopFindings+="</ul></div>"
                    $htmlResponse=$htmlResponse.Replace('<Findings>',$Findings)
                }
               $htmlResponse=$htmlResponse.Replace('<AssessmentStats>',$AssessmentStats)
              #  $htmlResponse=$htmlResponse.Replace('<Recommendation>',$apiResponse.recommendation)
            }

        

          return $htmlResponse
        }
    }
    End
    {
    }
}
