import spinal.core._
import spinal.core.sim._
import spinal.lib._
import spinal.lib.fsm._

import gay.vereena.cpu._
import gay.vereena.cpu.Util._
import gay.vereena.cpu.SimExtensions._


object GenerateSOC extends App {
    spinalConfig()
        .generateVerilog(SOC(Some(readBytes("program.bin"))))
}


object SimulateSOC extends App {
    SimConfig
        .withFstWave
        .withConfig(spinalConfig())
        .compile {
            val soc = SOC(Some(readBytes("program.bin")))

            soc
        }
        .doSim { soc =>
            val clk = soc.clockDomain.get

            clk.doResetCycles()

            clk.tick(512)
        }
}