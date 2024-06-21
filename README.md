# README

## Overview
This PowerShell script monitors and restarts the Windows Event Collector service upon detecting crashes, logging the actions performed.

## Configuration
- **Service Name**: Set the name of the service to monitor (default: "Windows Event Collector").
- **Event ID**: Set the event ID corresponding to service crashes (default: 7034).
- **Log File Path**: Set the path for the log file.

## Functions
1. **Get-CurrentDateTime**: Gets the current date and time for logging.
2. **Restart-ServiceIfNeeded**: Checks the service status and restarts or starts it if needed.
3. **Monitor-EventLog** (commented out): Monitors the event log for service crash events.

## Usage
1. Configure the service name, event ID, and log file path.
2. Use `Restart-ServiceIfNeeded` to monitor and restart the service.
3. (Optional) Uncomment and use `Monitor-EventLog` for continuous event log monitoring.

## Output
Logs the actions performed to the specified log file.
