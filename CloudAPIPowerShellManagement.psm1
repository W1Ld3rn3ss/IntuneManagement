#region Console functions

# https://stackoverflow.com/questions/40617800/opening-powershell-script-and-hide-command-prompt-but-not-the-gui
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);

[DllImport("kernel32.dll", SetLastError = true)]
public static extern bool SetConsoleIcon(IntPtr hIcon);

[DllImport("user32.dll")] 
public static extern int SendMessage(int hWnd, uint wMsg, uint wParam, IntPtr lParam); 
'

function Show-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()

    # Hide = 0,
    # ShowNormal = 1,
    # ShowMinimized = 2,
    # ShowMaximized = 3,
    # Maximize = 3,
    # ShowNormalNoActivate = 4,
    # Show = 5,
    # Minimize = 6,
    # ShowMinNoActivate = 7,
    # ShowNoActivate = 8,
    # Restore = 9,
    # ShowDefault = 10,
    # ForceMinimized = 11

    [Console.Window]::ShowWindow($consolePtr, 4)
}

function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0) | Out-Null
}

#endregion

# Unblock all files
# Not 100% OK but avoid issues with loading blocked files
function Unblock-AllFiles
{
    param($folder)

    (Get-ChildItem $folder -force | Where-Object {! $_.PSIsContainer}) | Unblock-File
    
    foreach($subFolder in (Get-ChildItem $folder -force | Where-Object {$_.PSIsContainer}))
    {
        Unblock-AllFiles $subFolder.FullName
    }
}

function Initialize-CloudAPIManagement
{
    [CmdletBinding(SupportsShouldProcess=$True)]
    param(
        [string]
        $View = "",
        [switch]
        $ShowConsoleWindow
    )

    $global:wpfNS = "xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation' xmlns:x='http://schemas.microsoft.com/winfx/2006/xaml'"

    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
    Add-Type -AssemblyName PresentationFramework

    try 
    {
        [xml]$xaml = Get-Content ([IO.Path]::GetDirectoryName($PSCommandPath) + "\Xaml\SplashScreen.xaml")
        $global:SplashScreen = ([Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml)))
        $global:txtSplashTitle = $global:SplashScreen.FindName("txtSplashTitle")
        $global:txtSplashText = $global:SplashScreen.FindName("txtSplashText")

        $global:txtSplashTitle.Text = ("Initializing Cloud API PowerShell Management")

        $global:SplashScreen.Show() | Out-Null
        [System.Windows.Forms.Application]::DoEvents()
    }
    catch 
    {
        
    }

    if($ShowConsoleWindow -ne $true)
    {
        Hide-Console
    }

    $global:txtSplashText.Text = "Unblock files" 
    [System.Windows.Forms.Application]::DoEvents()
    Unblock-AllFiles $PSScriptRoot

    $global:txtSplashText.Text = "Load core module"
    [System.Windows.Forms.Application]::DoEvents()
    Import-Module ($PSScriptRoot + "\Core.psm1") -Force -Global

    Start-CoreApp $View
}
