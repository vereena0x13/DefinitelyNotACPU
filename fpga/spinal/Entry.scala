import spinal.core._
import spinal.core.sim._
import spinal.lib._
import spinal.lib.fsm._

import gay.vereena.cpu._
import gay.vereena.cpu.Util._



object SimulateSOC extends App {
    SimConfig
        .withFstWave
        .withConfig(spinalConfig())
        .compile {
            val soc = SOC()

            

            soc
        }
        .doSim { soc =>
            
        }
}