"""
    memuse()

Get the memory usage in MB of current process.

See also: https://tech.hohoweiya.xyz/julia/#memory-allocation
"""
function memuse()
    pid = getpid()
    mem = round(Int,parse(Int,read(`ps -p $pid -o rss=`, String))/1024)
    println("current memory usage = $mem MB")
end