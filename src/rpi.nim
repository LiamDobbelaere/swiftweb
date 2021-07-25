import std/[parseutils, strutils]

proc measureGpuTempRaw*(): string =
    ## Measures the temperature, but returns the command output directly instead of parsing it.
    when defined windows:
        # Mock string for development because we don't have vcgencmd
        result = "temp=45.5'C"
    else:
        result = execProcess("vcgencmd measure_temp")

proc measureGpuTemp*(): float =
    ## Measures the temperature and returns it as a float.
    var tempRaw = measureGpuTempRaw()
    tempRaw = tempRaw.replace("temp=", "")
    tempRaw = tempRaw.replace("'C", "")

    discard parseFloat(tempRaw, result)

proc measureCpuTempRaw*(): string =
    ## Measures the temperature, but returns the command output directly instead of parsing it.
    when defined windows:
        # Mock string for development because we don't have vcgencmd
        result = "44388"
    else:
        result = readFile("/sys/class/thermal/thermal_zone0/temp")

proc measureCpuTemp*(): float =
    ## Measures the temperature and returns it as a float.
    var tempRaw = measureCpuTempRaw()

    discard parseFloat(tempRaw, result)
    result /= 1000.0