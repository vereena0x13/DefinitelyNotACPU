package gay.vereena.cpu

import java.io._
import scala.collection.mutable.ArrayBuffer

import spinal.core._
import spinal.core.sim._
import spinal.lib._
import spinal.lib.fsm._



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

    def readBytes(name: String): Array[Byte] = {
        val in = new DataInputStream(new FileInputStream(name))
        val xs = ArrayBuffer[Byte]()
        while(in.available() > 0) xs += in.readByte()
        in.close()
        xs.toArray
    }
}


object FSMExtensions {
    implicit class StateExt(val s: State) {
        def counting(ctr: UInt, lim: UInt, next: State, refrain: State = s, cond: Option[Bool] = None) = s.whenIsActive {
            cond match {
                case None       => _counting(ctr, lim, next, refrain)
                case Some(c)    => when(c) { _counting(ctr, lim, next, refrain) }
            }
        }

        private def _counting(ctr: UInt, lim: UInt, next: State, refrain: State) = {
            when(ctr === lim) {
                ctr := 0
                s.goto(next)
            } otherwise {
                ctr := ctr + 1
                if(s != refrain) s.goto(refrain)
            }
        }
    }
}


object SimExtensions {
    implicit class ClockDomainExt(val cd: ClockDomain) {
        def tickOnce(): Unit = {
            cd.clockToggle()
            sleep(1)
            cd.clockToggle()
            sleep(1)
        }

        def tick(n: Int): Unit = {
            for(_ <- 0 until n) tickOnce()
        }
        
        def tickUntil(c: () => Boolean, limit: Int = 1000): Boolean = {
            var i = 0
            while(!c() && i < limit) {
                tickOnce()
                i += 1
            }
            c()
        }

        def doResetCycles(): Unit = {
            cd.fallingEdge()
            sleep(0)

            cd.assertReset()
            cd.tick(6)
            cd.deassertReset()
            cd.tick(4)
        }
    }
}