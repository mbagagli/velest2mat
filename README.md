[![DOI](https://zenodo.org/badge/132815372.svg)](https://zenodo.org/badge/latestdoi/132815372) [![View velest2mat on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://ch.mathworks.com/matlabcentral/fileexchange/67283-velest2mat)

# velest2mat

Collection of shell scripts and Matlab functions to plot VELEST v4.5 results. The software and relative references can be found in the aknowledgement section.

**VERSION:** 1.2.3

**AUTHOR:**  Matteo Bagagli - <matteo.bagagli@erdw.ethz.ch> - [GitHub](https://github.com/mbagagli)

**LICENSE:**  GNU-GPL v3

## Getting Started
Once cloned the repository, add the `./bash` sub-directory to your shell path. When Matlab is open add to path the folder `./matlab` recursively by typing:

```
>> addpath(genpath(strcat(pwd,'/velest2mat','/matlab')))

```
## Usage

#### Shell
Before using matlab, the necessary files needs to be created beforehand with the shell script `velest2mat.sh`:

```
$ velest2mat.sh -l VELEST_MAINLOG -c VELEST_OUTCNV -s VELEST_STATCORRECTION
```
The flag variables are the relative or absolute path to the files you want to process. You can call the script with any combination of the 3 flags to receive  the needed output. The flag `-l VELEST_MAINLOG` calculate `vel2mat.HypoCorr` and `vel2mat.RMS`, the flag `-c VELEST_OUTCNV` calculate `vel2mat.latlondepmag`, the flag `-s VELEST_STATCORRECTION` calculate `vel2mat.statcorr`. The model files (input and output from VELEST `*.mod`), don't need any modification before he plotting routine call.

The script will create a local folder `velest2mat_files` where all the created files will be stored.

#### Matlab
To see the necessary input arguments, type on prompt:

```
>> help velest2mat
```

Once the routine is starded, a GUI should appear and ask the necessary files: use the `CHOOSE` button to navigate the system and select them. The example call has been done like this:

```
>> velest2mat('Be Happy!',[10,20],[10.5,21.5],[-3,20]);
[GUI]
Station Delay (*statcorr): 			velest2mat.statcorr
Eartquake File (*latlondepmag): 	velest2mat.latlondepmag
Vel. Model IN (*mod): 				velmod.in.mod
Vel. Model OUT(*mod): 				velmod.out.mod
Hypocenter Corr. (*HypoCorr): 		velest2mat.HypoCorr
Residual File (*RMS): 				velest2mat.RMS
```

If some warnings appears are because of special characters contained in
the station's name. This is absolutely irrelevant for the figure itself, so
don't worry.

These plot are meant to give an indication of the goodness/badness of the
VELEST run, but a more accurate look to the main and auxiliary logs should be
given in any case. I will try to maintain and update these tools (i.e. applying
backward compatibility for older MATLAB's version, improving the mapping
procedure etc...), but feel free to modify them as you want.

### Citing
If you plan to use this package for your scientifi publication, please **consider citing this repository** with the provided [DOI](doi.org/10.5281/zenodo.4292676):

```
@misc{mbagagli_2020_132815372,
    author       = {Matteo Bagagli},
    title        = {velest2mat: collection of routines for VELEST software analysis},
    month        = Nov,
    year         = 2020,
    doi          = {doi.org/10.5281/zenodo.4292676},
    version      = {v1.2.3},
    publisher    = {Zenodo},
    url          = {https://zenodo.org/record/4292676}
    }
```

------------

## Prerequisites

* MATLAB 9.0.0 R2016a or higher
* GNU bash v3.2 or higher

### Tests

* Tested on OSX El Capitan v10.11.6
* Tested on OSX El Capitan v11.0.1
* Tested on Ubuntu 16.04 LTS 64-bit (will work with any Debian distr.)
* Tested on Ubuntu 18.04 LTS 64-bit (will work with any Debian distr.)
* Tested on MATLAB 2016a/b 2017a/b 2018a/b 2019a/b 2020b

There should be no problem to be run also on Windows SO with Matlab installed.
Better to be used with Windows 10 that comes with ubuntu-like shells utilities.

### Filelist

```
./bash/
    |--- vel2mat.sh
```
```
./matlab/
    |--- VelestResult.m
    |--- histEQ.m
    |--- plotDistHypo.m
    |--- plotRMS.m
    |--- plotStatEpi.m
    |--- addScaleMap.m
    |--- plotDepthHypo.m
    |--- plotHypoAdj.m
    |--- plotStatCorr.m
    |--- plotVelMod.m
    |--- utils/
            |--- isanycell.m
            |--- myInputGUI.m
            |--- parseArgs.m
            |--- scatterLegend.m
```
```
./testfiles/
    |--- vel2mat.HypoCorr
    |--- vel2mat.latlondepmag
    |--- vel2mat.RMS
    |--- vel2mat.statcorr
    |--- figures/
            |--- VelestResult.pdf
            |--- StationCorr.pdf
```

### Aknowledgments
* The test figures are saved with the _export_fig_ package available [here](https://it.mathworks.com/matlabcentral/fileexchange/23629-export-fig).

### Reference
To know more about VELEST software:

* Kissling, E., Ellsworth, W.L., Eberhart‐Phillips, D. and Kradolfer, U., 1994. Initial reference models in local earthquake tomography. Journal of Geophysical Research: Solid Earth, 99(B10), pp.19635-19646.

For any bug reports/ issues send an e-mail to:
_matteo.bagagli@erdw.ethz.ch_
