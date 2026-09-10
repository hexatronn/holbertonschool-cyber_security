# BITS Persistence: Safe Lab, Detection, and Defense

> **Scope note:** This document is for an isolated lab and defensive training only.  
> It intentionally does **not** provide operational instructions for deploying malicious payloads or recreating persistence on a compromised machine. Use only on systems you own or are authorized to test.

---

## 1. Introduction

### Overview of BITS and its role in Windows
Background Intelligent Transfer Service (BITS) is a Windows service used for asynchronous, background file transfers. It is designed to be resilient, throttle network usage, and resume transfers after interruptions or reboots. Legitimate Windows components such as Windows Update, Microsoft Store, and some enterprise applications rely on BITS.

### How attackers abuse BITS for persistence and stealthy execution
Attackers abuse BITS because it is a trusted Windows component. BITS jobs can:

- Download files from remote locations.
- Retry failed transfers automatically.
- Persist across reboots.
- Blend into normal Windows traffic.
- Execute a command when a transfer completes through the notification command line feature.

Because BITS is legitimate, suspicious activity may be overlooked unless BITS-specific logging and monitoring are enabled.

---

## 2. Understanding BITS and Its Capabilities

### How BITS functions in Windows
BITS runs as a service and manages transfer jobs through a COM API. Administrators and scripts can interact with BITS using:

- `bitsadmin.exe`
- PowerShell `Start-BitsTransfer`, `Get-BitsTransfer`, `Complete-BitsTransfer`
- COM interfaces

BITS jobs can be created for the current user or all users, depending on privileges. Jobs have states such as queued, connecting, transferring, suspended, error, transient, and complete.

### Why attackers prefer BITS for covert operations
Attackers prefer BITS because:

- It is signed and trusted by Windows.
- It uses normal system processes and network paths.
- It can survive reboots and network interruptions.
- It can be configured with retry delays and priorities.
- It supports notification commands that can execute programs when a job completes.

Common abuse indicators include BITS jobs with remote URLs, unusual owners, suspicious notification command lines, and jobs downloading to temporary or user-writable directories.

---

## 3. Safe Lab: Enumerating and Creating a Benign BITS Job

> Perform this only in an isolated VM or lab environment. Do not use real malicious payloads.

### Lab setup
1. Use an isolated Windows VM with no access to production networks.
2. Start a local HTTP server hosting a harmless test file:

```bash
python -m http.server 8000
```

3. Create a local test directory:

```powershell
New-Item -ItemType Directory -Path C:\Lab -Force
```

### Enumerate existing BITS jobs
```powershell
bitsadmin /list /allusers /verbose
Get-BitsTransfer -AllUsers | Format-List *
Get-BitsTransfer -AllUsers |
    Select-Object DisplayName, JobState, Owner, TransferType, NotifyCmdLine
```

### Create a benign BITS download job
```cmd
bitsadmin /create /download LabBenignJob
bitsadmin /addfile LabBenignJob http://127.0.0.1:8000/benign.txt C:\Lab\benign.txt
bitsadmin /resume LabBenignJob
bitsadmin /info LabBenignJob /verbose
bitsadmin /complete LabBenignJob
```

### Important defensive note
Do **not** configure `/SetNotifyCmdLine` for execution in a production or unauthorized environment. For detection, inspect whether any existing job has a notification command line set.

---

## 4. Persistence Mechanism: Defensive Monitoring Instead of Re-Creation

Attackers may pair BITS with a Scheduled Task or WMI event subscription to check whether a job exists and recreate it if removed. That behavior is persistence and should not be deployed outside an authorized lab.

A safer defensive approach is to monitor BITS jobs and alert when suspicious jobs appear. The checker below does **not** recreate jobs; it logs and alerts.

### Example alert-only PowerShell checker
Save as `C:\Lab\Monitor-BitsJobs.ps1`:

```powershell
$Log = "C:\Lab\bits-monitor.log"
$Suspicious = @()

$jobs = Get-BitsTransfer -AllUsers -ErrorAction SilentlyContinue

foreach ($job in $jobs) {
    $notify = $job.NotifyCmdLine
    $urls = ($job.FileList | ForEach-Object { $_.RemoteName }) -join ";"

    if ($notify -or $urls -match 'http://|https://|ftp://') {
        $Suspicious += [PSCustomObject]@{
            Time          = Get-Date
            DisplayName   = $job.DisplayName
            Owner         = $job.Owner
            State         = $job.JobState
            NotifyCmdLine = $notify
            RemoteUrls    = $urls
        }
    }
}

if ($Suspicious.Count -gt 0) {
    $Suspicious | Format-Table -AutoSize | Out-String | Add-Content $Log
    Write-EventLog -LogName Application -Source "BITS Monitor" `
        -EventId 9001 -EntryType Warning `
        -Message "Suspicious BITS jobs detected. See $Log"
}
```

### Schedule the checker defensively
```powershell
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File C:\Lab\Monitor-BitsJobs.ps1"

$Trigger = New-ScheduledTaskTrigger -AtStartup

$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" `
    -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName "BITS Monitor" `
    -Action $Action -Trigger $Trigger -Principal $Principal
```

This provides visibility without implementing malicious persistence.

---

## 5. Detecting and Preventing Malicious BITS Jobs

### Event log sources
The primary log is:

```text
Microsoft-Windows-Bits-Client/Operational
```

Review events related to job creation, modification, completion, errors, and notification command lines.

### PowerShell event review
```powershell
Get-WinEvent -LogName Microsoft-Windows-Bits-Client/Operational -MaxEvents 100 |
Where-Object { $_.Message -match 'job|notify|command|transfer' } |
Format-List TimeCreated, Id, LevelDisplayName, Message
```

### Suspicious indicators
- `bitsadmin.exe` used with `/SetNotifyCmdLine`
- `Start-BitsTransfer` in unexpected scripts
- BITS jobs owned by unexpected users
- Jobs downloading from raw IP addresses or unknown domains
- Downloads to `%TEMP%`, `AppData`, or `ProgramData`
- Jobs with aggressive retry settings or high priority
- Scheduled Tasks that monitor or recreate BITS jobs

### Prevention and hardening
- Apply least privilege. Do not allow standard users to create system-wide BITS jobs.
- Restrict or monitor `bitsadmin.exe` and BITS PowerShell cmdlets.
- Use application control and EDR rules to detect suspicious BITS behavior.
- Monitor Scheduled Tasks and WMI event subscriptions.
- Restrict outbound network access and log proxy traffic.
- Disable BITS only if it is not required by business applications.
- Audit and alert on BITS notification command lines.
- Isolate and investigate hosts with suspicious BITS jobs.

### Response actions
1. Suspend or delete the suspicious BITS job.
2. Terminate any associated notification process.
3. Remove related Scheduled Tasks or WMI subscriptions.
4. Isolate the host if compromise is suspected.
5. Review network logs to identify the payload source.
6. Reimage or remediate based on organizational policy.

---

## 6. Conclusion

BITS is a legitimate Windows service that can be abused for stealthy downloading and persistence. Attackers value it because it is trusted, resilient, and can survive reboots. Defenders should focus on visibility: enumerate BITS jobs, monitor the BITS Operational log, detect notification command lines, and audit Scheduled Tasks.

Best practices:

- Monitor BITS activity continuously.
- Alert on unusual jobs, URLs, owners, and notification commands.
- Restrict administrative tools where possible.
- Use least privilege and application control.
- Keep labs isolated and never test persistence techniques on unauthorized systems.
