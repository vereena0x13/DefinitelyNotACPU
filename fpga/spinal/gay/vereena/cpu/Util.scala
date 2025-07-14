package gay.vereena.cpu

import spinal.core._



object Util {
    def spinalConfig(): SpinalConfig = SpinalConfig(
        targetDirectory = "gen",
        onlyStdLogicVectorAtTopLevelIo = true,
        mergeAsyncProcess = true,
        defaultConfigForClockDomains = ClockDomainConfig(
            resetKind = SYNC  
        ),
        defaultClockDomainFrequency = FixedFrequency(100 MHz),
        device = Device(
            vendor = "xilinx",
            family = "Artix 7"
        )
    )
}