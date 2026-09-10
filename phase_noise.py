#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: Phase noise
# Author: edecoux
# GNU Radio version: 3.10.12.0

from gnuradio import analog
from gnuradio import uhd
import time
import numpy as np
import threading
from gnuradio import gr
from gnuradio.filter import firdes
from gnuradio.fft import window
import sys
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation




class phase_noise(gr.top_block):

    def __init__(self, magnitude=0):
        gr.top_block.__init__(self, "Phase noise", catch_exceptions=True)

        ##################################################
        # Parameters
        ##################################################
        self.magnitude = magnitude

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 4e6

        ##################################################
        # Blocks
        ##################################################

        self.uhd_usrp_sink_0 = uhd.usrp_sink(
            ",".join(('', 'type=b200')),
            uhd.stream_args(
                cpu_format="fc32",
                args='',
                channels=list(range(0,2)),
            ),
            "",
        )
        self.uhd_usrp_sink_0.set_clock_source('external', 0)
        self.uhd_usrp_sink_0.set_time_source('external', 0)
        self.uhd_usrp_sink_0.set_samp_rate(samp_rate)
        # No synchronization enforced.

        self.uhd_usrp_sink_0.set_center_freq(200e6, 0)
        self.uhd_usrp_sink_0.set_gain(79, 0)

        self.uhd_usrp_sink_0.set_center_freq(200e6, 1)
        self.uhd_usrp_sink_0.set_antenna("TX/RX", 1)
        self.uhd_usrp_sink_0.set_gain(79, 1)
        self.analog_phase_modulator_fc_0_0 = analog.phase_modulator_fc(1)
        self.analog_phase_modulator_fc_0 = analog.phase_modulator_fc(1)
        self.analog_noise_source_x_0_0 = analog.noise_source_f(analog.GR_GAUSSIAN, magnitude, 42)
        self.analog_noise_source_x_0 = analog.noise_source_f(analog.GR_GAUSSIAN, magnitude, 0)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.analog_noise_source_x_0, 0), (self.analog_phase_modulator_fc_0, 0))
        self.connect((self.analog_noise_source_x_0_0, 0), (self.analog_phase_modulator_fc_0_0, 0))
        self.connect((self.analog_phase_modulator_fc_0, 0), (self.uhd_usrp_sink_0, 0))
        self.connect((self.analog_phase_modulator_fc_0_0, 0), (self.uhd_usrp_sink_0, 1))


    def get_magnitude(self):
        return self.magnitude

    def set_magnitude(self, magnitude):
        self.magnitude = magnitude
        self.analog_noise_source_x_0.set_amplitude(self.magnitude)
        self.analog_noise_source_x_0_0.set_amplitude(self.magnitude)

    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.uhd_usrp_sink_0.set_samp_rate(self.samp_rate)



def argument_parser():
    parser = ArgumentParser()
    parser.add_argument(
        "-m", "--magnitude", dest="magnitude", type=eng_float, default=eng_notation.num_to_str(float(0)),
        help="Set magnitude [default=%(default)r]")
    return parser


def main(top_block_cls=phase_noise, options=None):
    if options is None:
        options = argument_parser().parse_args()
    tb = top_block_cls(magnitude=options.magnitude)

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        sys.exit(0)

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    tb.start()

    try:
        input('Press Enter to quit: ')
    except EOFError:
        pass
    tb.stop()
    tb.wait()


if __name__ == '__main__':
    main()
