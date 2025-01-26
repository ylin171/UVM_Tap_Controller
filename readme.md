only need to compile **aaa_testbench_top.sv** and **tap_controller.sv (the design file)**, simulated in Modelsim

##### check functional coverage after the simulation (simulate aaa_tb_top, and hit run -all):

go to tool >> coverage report >> text >> choose details >> ok

##### setting UVM verbosity if needed:

can set verbosity by running:
vsim -sv_seed random +UVM_VERBOSITY=UVM_LOW -l sim.log aaa_tb_top in Modelsim
or set it in the build phase of test.sv by uncommenting the set_report_verbosity_level... line
Functional coverage report is in the sim directory
