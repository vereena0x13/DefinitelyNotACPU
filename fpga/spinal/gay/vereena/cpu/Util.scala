package gay.vereena.cpu

import java.io._
import scala.collection.mutable.ArrayBuffer

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

    def readInts(name: String): Array[Int] = {
        val in = new DataInputStream(new FileInputStream(name))
        val xs = ArrayBuffer[Int]()
        while(in.available() > 0) xs += in.readInt()
        in.close()
        xs.toArray
    }
}