import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

TEST = 0
USE_CHEAP_BIAS = False # True

def neuron(id, x):
    if USE_CHEAP_BIAS:
        return bin(bin(x & weights[id]).count("1") & bias[id]).count("1") > 0;
    else:
        return bin(x & weights[id]).count("1") > bias[id];

if TEST == 0: # 1 layer
    MAX_TEST_OUTPUTS = 8
    MAX_NEURON_PARAMS_TO_UPLOAD = 8
    weights = [0xff, 0xff, 0xff, 0xff, 0x55, 0xAA, 0x0F, 0xFF] # 0xC3
    bias =    [   3,    1,    2,    7,    3,    3,    3,    3] # [   0,    1,    2,    7,    3,    3,    3,    3]
    bits_w =  [   8,    8,    8,    8,    8,    8,    8,    8]
    bits_b =  [   3,    3,    3,    3,    3,    3,    3,    3]
    def output(id, x): return neuron(id, x)

elif TEST == 1: # 2 layers
    HIDDEN_UNITS = 8
    MAX_TEST_OUTPUTS = 8
    MAX_NEURON_PARAMS_TO_UPLOAD = 8+8
    weights = [0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80,    0xff, 0xff, 0xff, 0xff, 0x55, 0xAA, 0x0F, 0xC3]
    bias =    [   0,    0,    0,    0,    0,    0,    0,    0,       0,    1,    2,    7,    3,    3,    3,    3]
    bits_w =  [   8,    8,    8,    8,    8,    8,    8,    8,       8,    8,    8,    8,    8,    8,    8,    8]
    bits_b =  [   3,    3,    3,    3,    3,    3,    3,    3,       3,    3,    3,    3,    3,    3,    3,    3]
    def output(id, x):
        h = 0
        for n in reversed(range(HIDDEN_UNITS)):
            h = (h << 1) + neuron(n, x)
        return neuron(HIDDEN_UNITS+id, h)

elif TEST == 2: # 2 layers
    HIDDEN_UNITS = 12
    MAX_TEST_OUTPUTS = 8
    MAX_NEURON_PARAMS_TO_UPLOAD = 12+8
    weights = [0xff,0xff,0xff,0xff,0x55,0xAA,0x0F,0xC3,0xff,0xff,0xff,0xff,     0xfff,0xfff,0xfff,0xfff,0xfff,0xfff,0xfff,0xfff]
    bias =    [   0,   1,   2,   7,   3,   3,   3,   3,   3,   4,   5,   6,         0,    1,    2,    3,    4,    5,    6,    7]
    bits_w =  [   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,        12,   12,   12,   12,   12,   12,   12,   12]
    bits_b =  [   3,   3,   3,   3,   3,   3,   3,   3,   3,   3,   3,   3,         3,    3,    3,    3,    3,    3,    3,    3]
    def output(id, x):
        h = 0
        for n in reversed(range(HIDDEN_UNITS)):
            h = (h << 1) + neuron(n, x)
        #print("{0:016b}".format(h), int(neuron(HIDDEN_UNITS+id, h)))
        return neuron(HIDDEN_UNITS+id, h)

elif TEST == 3: # 2 layers
    HIDDEN_UNITS = 16
    MAX_TEST_OUTPUTS = 8
    MAX_NEURON_PARAMS_TO_UPLOAD = 16+8
    weights = [0xff,0xff,0xff,0xff,0x55,0xAA,0x0F,0xC3,0xff,0xff,0xff,0xff,0x01,0x02,0x04,0x08,     0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff,0xffff]
    bias =    [   0,   1,   2,   7,   3,   3,   3,   3,   3,   4,   5,   6,   0,   0,   0,   0,          0,     1,     2,     3,     4,     5,     6,     7]
    bits_w =  [   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,   8,         16,    16,    16,    16,    16,    16,    16,    16]
    bits_b =  [   3,   3,   3,   3,   3,   3,   3,   3,   3,   3,   3,   3,   3,   3,   3,   3,          3,     3,     3,     3,     3,     3,     3,     3]
    def output(id, x):
        h = 0
        for n in reversed(range(HIDDEN_UNITS)):
            h = (h << 1) + neuron(n, x)
        #print("{0:016b}".format(h), int(neuron(HIDDEN_UNITS+id, h)))
        return neuron(HIDDEN_UNITS+id, h)

elif TEST == 4: # 3 layers
    HIDDEN_UNITS = 8
    HIDDEN_UNITS2 = 8
    MAX_TEST_OUTPUTS = 8
    MAX_NEURON_PARAMS_TO_UPLOAD = 8+8+8
    weights = [0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80,    0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,    0xff, 0xff, 0xff, 0xff, 0x55, 0xAA, 0x0F, 0xC3]
    bias =    [   0,    0,    0,    0,    0,    0,    0,    0,       0,    7,    0,    7,    0,    7,    0,    7,       0,    1,    2,    7,    3,    3,    3,    3]
    bits_w =  [   8,    8,    8,    8,    8,    8,    8,    8,       8,    8,    8,    8,    8,    8,    8,    8,       8,    8,    8,    8,    8,    8,    8,    8]
    bits_b =  [   3,    3,    3,    3,    3,    3,    3,    3,       3,    3,    3,    3,    3,    3,    3,    3,       3,    3,    3,    3,    3,    3,    3,    3]
    def output(id, x):
        h = 0
        h2 = 0
        for n in reversed(range(HIDDEN_UNITS)):
            h = (h << 1) + neuron(n, x)
        for n in reversed(range(HIDDEN_UNITS2)):
            h2 = (h2 << 1) + neuron(HIDDEN_UNITS+n, h)
        return neuron(HIDDEN_UNITS+HIDDEN_UNITS2+id, h2)


def nth_bit(x, n):
    return (x >> n) & 1

@cocotb.test()
async def test_tiny_dnn(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # dut.setup.value = 0
    # dut.x.value = 0;
    # await ClockCycles(dut.clk, 10)

    dut._log.info("setup")
    dut.setup.value = 1

    # for n in reversed(range(8)):
    #     for i in reversed(range(3 + 8)):
    #         dut.x.value = nth_bit(bias[n], 0);
    #         await ClockCycles(dut.clk, 1)

    for n in reversed(range(min(MAX_NEURON_PARAMS_TO_UPLOAD, len(weights)))):
        for i in reversed(range(bits_b[n])):
            dut.param_in.value = nth_bit(bias[n], i);
            await ClockCycles(dut.clk, 1)
        for i in reversed(range(bits_w[n])):
            dut.param_in.value = nth_bit(weights[n], i);
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
    for x in range(255): # only first 6 out of 8 bits are passed to neural net right now
        dut._log.info("input {}".format(x))
        dut.x.value = x
        dut.x_bank_hi.value = 0
        await ClockCycles(dut.clk, 2)
        dut.x_bank_hi.value = 1
        await ClockCycles(dut.clk, 10)
        print(dut.out.value)
        for n in range(min(MAX_TEST_OUTPUTS, len(weights))):
            assert int(dut.out[n].value) == output(n, x)
