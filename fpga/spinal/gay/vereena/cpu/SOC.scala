package gay.vereena.cpu

import scala.collection.mutable.ArrayBuffer
import scala.math

import spinal.core._
import spinal.lib._
import spinal.lib.fsm._


case class SOC(initial_memory: Option[Array[Byte]]) extends Component {
    val cpu             = CPU()

    val ram = {
        val ramSize     = math.pow(2, 16).toInt
        val ram         = Mem(UInt(8 bits), ramSize)
        if(initial_memory.isDefined) {
            assert(initial_memory.get.length <= ram.wordCount)
            val arr = ArrayBuffer[BigInt]()
            arr ++= initial_memory.get.map(x => BigInt(x & 0xFFFF))
            while(arr.length < ramSize) arr += BigInt(0)
            ram.initBigInt(arr, true)
        }
        ram
    }

    cpu.io.read_data    := ram.readAsync(cpu.io.addr)
    ram.write(cpu.io.addr, cpu.io.write_data, cpu.io.write)
}