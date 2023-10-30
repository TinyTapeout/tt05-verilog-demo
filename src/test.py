import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_my_design(dut):
    
    CONSTANT_CURRENT = 40  # For example, injecting half the max value

    dut._log.info("Start simulation")
    # initialize clock
    clock = Clock(dut.clk, 1, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0 # low to reset
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1 # take out of reset
    dut.ui_in.value = CONSTANT_CURRENT
    dut.ena.value = 1 # enable design

    for _ in range(100):  # Run for 100 clock cycles, can be adjusted as needed
        await RisingEdge(dut.clk)
    
    dut._log.info("Finished test!")



#     # Initialize
#     dut._log.info("Initializing Simulation.")
#     dut.ui_in.value = CONSTANT_CURRENT
#     dut.rst_n.value = 0
#     dut.ena.value = 0
#     await RisingEdge(dut.clk)
#     dut.rst_n.value = 1
#     dut.ena.value = 1

#     for _ in range(100):  # Run for 100 clock cycles, can be adjusted as needed
#         await RisingEdge(dut.clk)
    
#         dut._log.info("Finished test!")