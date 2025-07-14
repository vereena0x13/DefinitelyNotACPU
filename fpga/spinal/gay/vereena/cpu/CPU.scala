package gay.vereena.cpu

import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

import gay.vereena.cpu.Util._



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
        val bus             = master(Bus())
    }
    import io._


    bus.cmd.write           := False
    bus.cmd.valid.setAsReg() init(False)


    val addr                = UInt(16 bits)
    val data                = UInt(8 bits)

    val upc                 = Reg(UInt(4 bits)) init(0)
    val pc                  = Reg(UInt(16 bits)) init(0)
    val mar                 = Reg(UInt(16 bits)) init(0)
    val ir                  = Reg(UInt(8 bits)) init(0)
    val a                   = Reg(UInt(8 bits)) init(0)
    val b                   = Reg(UInt(8 bits)) init(0)
    val flags               = new Bundle {
        val z               = Reg(Bool()) init(False)
        val c               = Reg(Bool()) init(False)
    }


    val ctrl    = new Bundle {
        // TODO: really we should just like, parse the microcode out of the ucode_xx.h files in cpu_ctrl.
        val ucode           = Mem(UInt(32 bits), readInts("ucode.bin").map(x => U((x & 0xFFFFFFFFL).toLong)))
        
        val uaddr           = flags.c ## flags.z ## ir(5 downto 0) ## upc
        val uinsn           = ucode.readAsync(uaddr.asUInt)
        
        /*
        val d               = uinsn(7 downto 0)
        val d_rd            = uinsn(8)
        val alu_xorb        = uinsn(9)
        val alu_ci          = uinsn(10)
        val alu_bit_rd      = uinsn(11)
        val pc_rd           = uinsn(12)
        val pc_inc          = uinsn(13)
        val pc_ld           = uinsn(14)
        val mar_rd          = uinsn(15)
        val mar_lo_ld       = uinsn(16)
        val mar_hi_ld       = uinsn(17)
        val a_rd            = uinsn(18)
        val a_ld            = uinsn(19)
        val b_ld            = uinsn(20)
        val flags_ld        = uinsn(21)
        val upc_rst         = uinsn(22)
        val ram_rd          = uinsn(23)
        val ram_wr          = uinsn(24)
        val ir_ld           = uinsn(25)
        val addr_lo_to_d    = uinsn(26)
        val addr_hi_to_d    = uinsn(27)
        val d_to_mar_lo     = uinsn(29)
        val d_to_mar_hi     = uinsn(28)
        val upc_inc         = uinsn(30)
        val alu_rd          = uinsn(31)
        */
    }





    bus.cmd.addr            := addr
    bus.cmd.data            := data
    // bus.cmd.write           := ctrl.ram_wr
}