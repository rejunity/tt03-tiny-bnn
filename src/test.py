import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles


MAX_TEST_NEURONS = 8
weights = [0xff, 0xff, 0xff, 0xff, 0x55, 0xAA, 0x0F, 0xC3]
bias =    [   0,    1,    2,    7,    3,    3,    3,    3]

def neuron(id, x):
    return bin(x & weights[id]).count("1") > bias[id];

def nth_bit(x, n):
    return (x >> n) & 1

@cocotb.test()
async def test_7seg(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # dut.setup.value = 0
    # dut.x.value = 0;
    # await ClockCycles(dut.clk, 10)

    dut._log.info("setup")
    dut.setup.value = 1

    for n in reversed(range(min(MAX_TEST_NEURONS, len(weights)))):
        for i in reversed(range(3)):
            dut.x.value = nth_bit(bias[n], i);
            await ClockCycles(dut.clk, 1)
        for i in reversed(range(8)):
            dut.x.value = nth_bit(weights[n], i);
            await ClockCycles(dut.clk, 1)

    # dut.x.value = 0;
    # await ClockCycles(dut.clk, 1)
    # dut.x.value = 1;
    # await ClockCycles(dut.clk, 2)
    # dut.x.value = 1;
    # await ClockCycles(dut.clk, 8)

    # dut.x.value = 0;
    # await ClockCycles(dut.clk, 2)
    # dut.x.value = 1;
    # await ClockCycles(dut.clk, 1)
    # dut.x.value = 1;
    # await ClockCycles(dut.clk, 8)

    dut.setup.value = 0
    await ClockCycles(dut.clk, 10)

    dut._log.info("vary inputs")
    for x in range(64): # only first 6 out of 8 bits are passed to neural net right now
        dut._log.info("input {}".format(x))
        dut.x.value = x
        await ClockCycles(dut.clk, 10)
        print(dut.out.value)
        for n in range(min(MAX_TEST_NEURONS, len(weights))):
            assert int(dut.out[n].value) == neuron(n, x)
