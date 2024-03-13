#Install the MSGraph Powershell Module
Install-Module -Name MSAL.PS

#Provide your Office 365 Tenant Domain Name or Tenant Id
$TenantId = "XXXXXX"
#$TenantId = "XXXXXX"
   
#Your Azure AppID
$AppClientId="XXXXXXXX"  
   
$MsalParams = @{
   ClientId = $AppClientId
   TenantId = $TenantId
   Scopes   = "https://graph.microsoft.com/User.Read.All","https://graph.microsoft.com/AuditLog.Read.All"
}
  
$MsalResponse = Get-MsalToken @MsalParams
$AccessToken  = $MsalResponse.AccessToken

#Get EntraID users that are Syncing from OnPrem
$EntraID = Get-MgUser -All -Filter "OnPremisesSyncEnabled eq true" 
# Get all Azure AD Users
$AD = get-aduser -filter * -Properties * 

#Put User PrincipalName to an Array
$EntraIDUPN=$EntraID.UserPrincipalName
$ADUPN=$AD.UserPrincipalName

# PerForm a For-Each Object Loop to find the Users how are Orphaned in EntraAD

$EntraIDUPN | ForEach-Object {
     if ($ADUPN-notcontains $_) {
         Write-Host "$_"
 } 
}
