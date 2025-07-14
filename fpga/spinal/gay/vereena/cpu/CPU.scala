package gay.vereena.cpu

import spinal.core._
import spinal.lib._
import spinal.lib.fsm._

import gay.vereena.cpu.Util._



case class CPU() extends Component {
    val io = new Bundle {
        val addr            = out UInt(16 bits)
        val write_data      = out UInt(8 bits)
        val read_data       = in UInt(8 bits)
        val write           = out Bool()
    }


    val addr                = UInt(16 bits)
    addr                    := 0
    val data                = UInt(8 bits)
    data                    := 0


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

    val mar_lo              = UInt(8 bits)
    mar_lo                  := 0
    val mar_hi              = UInt(8 bits)
    mar_hi                  := 0

    val zero                = Bool()
    zero                    := False
    val carry               = Bool()
    carry                   := False


    val ctrl    = new Bundle {
        // TODO: really we should just like, parse the microcode out of the ucode_xx.h files in cpu_ctrl.
        val ucode           = Mem(UInt(32 bits), readInts("ucode.bin").map(x => U((x & 0xFFFFFFFFL).toLong)))
        
        val uaddr           = flags.c ## flags.z ## ir(5 downto 0) ## upc
        val uinsn           = ucode.readAsync(uaddr.asUInt)
        
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
    }


    when(ctrl.pc_rd)        { addr := pc }
    when(ctrl.pc_inc)       { pc := pc + 1 }
    when(ctrl.mar_rd)       { addr := mar }
    
    when(ctrl.a_rd)         { data := a }           
    when(ctrl.addr_lo_to_d) { data := addr(7 downto 0) }   
    when(ctrl.addr_hi_to_d) { data := addr(15 downto 8) }   
    when(ctrl.ram_rd)       { data := io.read_data }         

    when(ctrl.alu_rd) {
        val sum             = UInt(9 bits)
        val x               = (U(0, 1 bit) ## a).asUInt
        val y               = (U(0, 1 bit) ## b).asUInt
        val c               = ctrl.alu_ci.asUInt
        when(ctrl.alu_xorb) {
            sum             := x - y + c - 1
            carry           := (sum & 0x100) === 0
        } otherwise {
            sum             := x + y + c
            carry           := sum > 0xFF
        }     
        data                := sum(7 downto 0)
        zero                := data === 0
    }

    when(ctrl.alu_bit_rd) {
        switch(ir & 0b00000011) {
            is(0) { data := (b << 1)(7 downto 0) }
            is(1) { data := (b >> 1).expand }
            default {
                switch(ctrl.uinsn & 0x600) {
                    is(0) { data := a & b }
                    is(0x200) { data := a | b }
                    is(0x400) { data := a ^ b }
                    default {  }
                }
            }
        }
    }

    when(ctrl.d_to_mar_lo)  { mar_lo := data }
    when(ctrl.d_to_mar_hi)  { mar_hi := data }

    when(ctrl.pc_ld)        { pc := addr }
    when(ctrl.mar_lo_ld)    { mar(7 downto 0) := data }
    when(ctrl.mar_hi_ld)    { mar(15 downto 8) := data }

    when(ctrl.a_ld)         { a := data }
    when(ctrl.b_ld)         { b := data }

    when(ctrl.flags_ld)     {
        flags.z             := zero
        flags.c             := carry
    }

    when(ctrl.ir_ld)        { ir := data }

    new ClockingArea(ClockDomain.current.copy(clock = ~ClockDomain.current.readClockWire)) {
        when(ctrl.upc_inc)      { upc := upc + 1 }
    }

    when(ctrl.upc_rst)      { upc := 0 }

    io.addr                 := addr
    io.write_data           := data
    io.write                := ctrl.ram_wr
}