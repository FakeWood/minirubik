# Run a spinning Ripes program in CLI mode and read Ripes' memory use while it runs.
#
# Usage (from the minirubik folder):
#   .\measure_mem.ps1 -Src .\bench_mem.s -Runs 3
#
# Switch the lui constant in the .s file between N_BYTE_SMALL and N_BYTE_LARGE
# yourself, and run this once for each build.

param(
    [Parameter(Mandatory)] [string] $Src,
    [string] $Ripes = "$PSScriptRoot\..\Ripes-v2.2.6-106-g5b8a616-win-x86_64\Ripes.exe",
    [string] $Proc = 'RV32_ISS',
    [int] $Runs = 3,
    [int] $WaitSeconds = 5,        # wait before each read; the store loop must be done by then
    [int] $TimeoutMs = 20000       # must exceed 2 * WaitSeconds so Ripes is alive for both reads
)

$Src = (Resolve-Path $Src).Path
$Ripes = (Resolve-Path $Ripes).Path
if ($TimeoutMs -le 2 * $WaitSeconds * 1000) {
    throw "TimeoutMs ($TimeoutMs) must be larger than 2 * WaitSeconds * 1000."
}

$results = foreach ($run in 1..$Runs) {
    $p = Start-Process $Ripes -PassThru -WindowStyle Hidden -ArgumentList `
        '--mode', 'cli', '--src', "`"$Src`"", '-t', 'asm', '--proc', $Proc, '--timeout', $TimeoutMs

    $reads = foreach ($i in 1..2) {
        Start-Sleep -Seconds $WaitSeconds
        $p.Refresh()
        if ($p.HasExited) { throw "Ripes exited before read $i of run $run (check --src path or timeout)." }
        [pscustomobject]@{
            WorkingSet  = $p.WorkingSet64
            PeakWorking = $p.PeakWorkingSet64
            Private     = $p.PrivateMemorySize64
        }
    }
    $p.WaitForExit()

    [pscustomobject]@{
        Run              = $run
        WorkingSet_1     = $reads[0].WorkingSet
        WorkingSet_2     = $reads[1].WorkingSet
        PeakWorkingSet_2 = $reads[1].PeakWorking
        Private_2        = $reads[1].Private
    }
}

"Source: $Src"
"Processor: $Proc"
$results | Format-Table -AutoSize
