Very simple loader that proved effective at getting past AV/EDR (At the time)

The loader was debugged until it was found what methods of loading SC were setting it off.
From there this approach simplified what was in use by finding alternatives.
Nothing fancy with syscalls and assembly just the use of less flagged techniques.
I would stay away from things like meterpreter unless your going to perform some serious evasion it will most likely get caught in memory.
Then again theres always amsii bypass. I've found the VirtualProtect a lot more accepted then VirutalAlloc or VIrutalAllocEx, etc.
From memory it would sometimes still alert but allow the injection to take place.

 - Liquidsky
