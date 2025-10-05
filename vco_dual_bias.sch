v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 140 -280 140 -240 {lab=vdd}
N 140 -180 180 -180 {lab=vdd_inv1}
N 180 -180 180 -160 {lab=vdd_inv1}
N 180 -100 180 -80 {lab=out1}
N 180 -20 180 0 {lab=gnd_inv1}
N 140 0 180 0 {lab=gnd_inv1}
N 140 60 140 100 {lab=GND}
N 400 -280 400 -240 {lab=vdd}
N 400 -180 440 -180 {lab=vdd_inv2}
N 440 -180 440 -160 {lab=vdd_inv2}
N 440 -100 440 -80 {lab=out2}
N 440 -20 440 0 {lab=gnd_inv2}
N 400 0 440 0 {lab=gnd_inv2}
N 400 60 400 100 {lab=GND}
N 660 -280 660 -240 {lab=vdd}
N 660 -180 700 -180 {lab=vdd_inv3}
N 700 -180 700 -160 {lab=vdd_inv3}
N 700 -100 700 -80 {lab=in1}
N 700 -20 700 0 {lab=gnd_inv3}
N 660 0 700 0 {lab=gnd_inv3}
N 660 60 660 100 {lab=GND}
N 180 -80 240 -80 {lab=out1}
N 240 -80 240 -120 {lab=out1}
N 240 -120 380 -120 {lab=out1}
N 380 -120 380 -80 {lab=out1}
N 380 -80 440 -80 {lab=out1}
N 440 -80 500 -80 {lab=out2}
N 500 -80 500 -120 {lab=out2}
N 500 -120 640 -120 {lab=out2}
N 640 -120 640 -80 {lab=out2}
N 640 -80 700 -80 {lab=out2}
N 700 -80 760 -80 {lab=in1}
N 760 -200 760 -80 {lab=in1}
N 120 -200 760 -200 {lab=in1}
N 120 -200 120 -80 {lab=in1}
N 120 -80 180 -80 {lab=in1}
C {vsource.sym} -80 -180 0 0 {name=Vdd value=1.8}
C {vsource.sym} -80 -80 0 0 {name=Vbias_p value=0.9}
C {vsource.sym} -80 20 0 0 {name=Vbias_n value=0.9}
C {gnd.sym} -80 -150 0 0 {name=l2 lab=GND}
C {gnd.sym} -80 -50 0 0 {name=l3 lab=GND}
C {gnd.sym} -80 50 0 0 {name=l4 lab=GND}
C {lab_pin.sym} -80 -210 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {lab_pin.sym} -80 -110 0 0 {name=p2 sig_type=std_logic lab=vbias_p}
C {lab_pin.sym} -80 -10 0 0 {name=p3 sig_type=std_logic lab=vbias_n}
C {lab_pin.sym} 140 -280 1 0 {name=p4 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 400 -280 1 0 {name=p5 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 660 -280 1 0 {name=p6 sig_type=std_logic lab=vdd}
C {gnd.sym} 140 100 0 0 {name=l5 lab=GND}
C {gnd.sym} 400 100 0 0 {name=l6 lab=GND}
C {gnd.sym} 660 100 0 0 {name=l7 lab=GND}
C {lab_pin.sym} 180 -180 2 0 {name=p7 sig_type=std_logic lab=vdd_inv1}
C {lab_pin.sym} 440 -180 2 0 {name=p8 sig_type=std_logic lab=vdd_inv2}
C {lab_pin.sym} 700 -180 2 0 {name=p9 sig_type=std_logic lab=vdd_inv3}
C {lab_pin.sym} 180 0 2 0 {name=p10 sig_type=std_logic lab=gnd_inv1}
C {lab_pin.sym} 440 0 2 0 {name=p11 sig_type=std_logic lab=gnd_inv2}
C {lab_pin.sym} 700 0 2 0 {name=p12 sig_type=std_logic lab=gnd_inv3}
C {lab_pin.sym} 240 -80 1 0 {name=p13 sig_type=std_logic lab=out1}
C {lab_pin.sym} 500 -80 1 0 {name=p14 sig_type=std_logic lab=out2}
C {lab_pin.sym} 760 -80 2 0 {name=p15 sig_type=std_logic lab=in1}
C {sky130_fd_pr/pfet_01v8.sym} 160 -210 0 1 {name=M1_ctrl_p
L=0.15
W=2.0
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'"
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'"
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 160 30 0 1 {name=M1_ctrl_n
L=0.15
W=1.0
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'"
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'"
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 420 -210 0 1 {name=M2_ctrl_p
L=0.15
W=2.0
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'"
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'"
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 420 30 0 1 {name=M2_ctrl_n
L=0.15
W=1.0
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'"
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'"
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 680 -210 0 1 {name=M3_ctrl_p
L=0.15
W=2.0
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'"
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'"
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 680 30 0 1 {name=M3_ctrl_n
L=0.15
W=1.0
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'"
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'"
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 200 -130 0 1 {name=M1_p
L=0.15
W=0.84
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'"
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'"
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 200 -50 0 1 {name=M1_n
L=0.15
W=0.42
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'"
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'"
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 460 -130 0 1 {name=M2_p
L=0.15
W=0.84
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'"
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'"
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 460 -50 0 1 {name=M2_n
L=0.15
W=0.42
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'"
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'"
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/pfet_01v8.sym} 720 -130 0 1 {name=M3_p
L=0.15
W=0.84
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'"
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'"
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=pfet_01v8
spiceprefix=X
}
C {sky130_fd_pr/nfet_01v8.sym} 720 -50 0 1 {name=M3_n
L=0.15
W=0.42
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.29'"
pd="'2*int((nf+1)/2) * (W/nf + 0.29)'"
as="'int((nf+2)/2) * W/nf * 0.29'"
ps="'2*int((nf+2)/2) * (W/nf + 0.29)'"
nrd="'0.29 / W'" nrs="'0.29 / W'"
sa=0 sb=0 sd=0
model=nfet_01v8
spiceprefix=X
}
C {lab_pin.sym} 100 -210 0 0 {name=p16 sig_type=std_logic lab=vbias_p}
C {lab_pin.sym} 100 30 0 0 {name=p17 sig_type=std_logic lab=vbias_n}
C {lab_pin.sym} 360 -210 0 0 {name=p18 sig_type=std_logic lab=vbias_p}
C {lab_pin.sym} 360 30 0 0 {name=p19 sig_type=std_logic lab=vbias_n}
C {lab_pin.sym} 620 -210 0 0 {name=p20 sig_type=std_logic lab=vbias_p}
C {lab_pin.sym} 620 30 0 0 {name=p21 sig_type=std_logic lab=vbias_n}
C {lab_pin.sym} 140 -130 0 0 {name=p22 sig_type=std_logic lab=in1}
C {lab_pin.sym} 140 -50 0 0 {name=p23 sig_type=std_logic lab=in1}
C {lab_pin.sym} 400 -130 0 0 {name=p24 sig_type=std_logic lab=out1}
C {lab_pin.sym} 400 -50 0 0 {name=p25 sig_type=std_logic lab=out1}
C {lab_pin.sym} 660 -130 0 0 {name=p26 sig_type=std_logic lab=out2}
C {lab_pin.sym} 660 -50 0 0 {name=p27 sig_type=std_logic lab=out2}
C {code.sym} -220 -280 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.lib $::SKYWATER_MODELS/sky130.lib.spice tt
.include $::SKYWATER_STDCELLS/sky130_fd_sc_hd.spice
"
spice_ignore=false}
C {code.sym} -220 -140 0 0 {name=SIMULATION
only_toplevel=false
value="
.ic v(in1)=0 v(out1)=1.8 v(out2)=0
.tran 0.1n 300n
.control
run
plot v(in1) v(out1) v(out2)
.endc
"}
