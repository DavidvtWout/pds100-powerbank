# XY-PDS100 Battery Adapter

This repository contains an OpenSCAD model of a battery case adapter for the XY-PDS100 PCB. The adapter is designed to be mounted on a Parkside 20V battery or an Active Energy 20V/40V battery.

![XY-PDS100 Battery Case Adapter](./images/XY-PDS100-adapter-preview.jpg)


## Bill of Materials

- 4 optional M3 brass heat-set inserts (for threaded holes)
- 4 M3 button head or socket head screws with a length between 10 and 14 mm
- 2 M2x10 self-tapping screws
- Approximately 20 cm of wire capable of handling around 5A (e.g., 18 AWG wire)
- 2 (for Parkside) or 4 (for Active Energy) solder/crimp-style flat connectors (also known as spade, fork, or blade connectors) for attaching the wire ends


## 3D Printing

The models have been designed for ease of printing and can mostly be printed without supports. However, the PDS100 case may require some support material. The models have been successfully printed with ABS, but other materials like PLA or PETG should also work.

For PLA, consider increasing the wall thickness to ensure the structural integrity of the printed parts.

The parts are modeled in the orientation they should be printed, so no rotation is needed before slicing. Keep in mind that the tolerances are tight, and the shrinkage of the printed material should be accounted for. Adjust the `horizontal_expansion` setting in your slicer accordingly to compensate for material shrinkage.

Here are some general printing recommendations:

- Layer height: 0.2mm
- Number of walls: 3 or more
- Supports: Only needed for the PDS100 case

Remember to fine-tune your slicer settings according to your specific printer and material for optimal results.


## Assembly Instructions

TODO


## License

This project is licensed under the Apache licence - see the [LICENSE.md](./LICENSE.md) file for details.
