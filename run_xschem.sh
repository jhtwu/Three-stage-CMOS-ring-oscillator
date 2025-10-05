#!/bin/bash
# Launch Xschem with proper library paths for VCO project

export XSCHEM_LIBRARY_PATH="/usr/share/xschem/xschem_library/devices:\
$HOME/.xschem/xschem_library:\
/usr/share/xschem/xschem_library:\
/opt/pdk/sky130A/libs.tech/xschem:\
/opt/pdk/sky130A/libs.tech/xschem/sky130_fd_pr:\
/opt/pdk/sky130A/libs.tech/xschem/sky130_stdcells"

export SKYWATER_MODELS=/opt/pdk/sky130A/libs.tech/ngspice
export SKYWATER_STDCELLS=/opt/pdk/sky130A/libs.ref/sky130_fd_sc_hd/spice

echo "XSCHEM_LIBRARY_PATH set to:"
echo "$XSCHEM_LIBRARY_PATH" | tr ':' '\n'
echo ""
echo "Opening vco_dual_bias.sch..."

cd "$(dirname "$0")"
xschem vco_dual_bias.sch
