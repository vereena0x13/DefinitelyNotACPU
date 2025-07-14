package gay.vereena.cpu

import spinal.core._
import spinal.lib._
import spinal.lib.fsm._



case class BusCmd() extends Bundle {
    val addr    = UInt(16 bits)
    val data    = UInt(8 bits)
    val write   = Bool()
}

case class BusRsp() extends Bundle with IMasterSlave {
    val data    = UInt(8 bits)

    def asMaster(): Unit = {
        out(data)
    }
}

case class Bus() extends Bundle with IMasterSlave {
    val cmd     = Stream(BusCmd())
    val rsp     = BusRsp()

    def asMaster(): Unit = {
        master(cmd)
        slave(rsp)
    }
}


case class CPU() extends Component {
    val io = new Bundle {
        val bus = master(Bus())
    }
    import io._


    val pc      = Reg(UInt(16 bits)) init(0)
    val mar     = Reg(UInt(16 bits)) init(0)
    val ir      = Reg(UInt(8 bits)) init(0)
    val a       = Reg(UInt(8 bits)) init(0)
    val b       = Reg(UInt(8 bits)) init(0)



}