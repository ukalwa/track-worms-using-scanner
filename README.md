# Software to track nematodes *(H. Glycines)* and analyze behavior at different drug concentrations

This software is written for our [paper] in *Phytopathology*:
*"Movement and Motion of Soybean Cyst Nematode, Heterodera glycines,
Populations and Individuals in Response to Abamectin"*

## Requirments

### Environment Setup

- Download & Install [Matlab R2016a]
- A Flatbed scanner to scan high resolution (atleast 1200 dpi) images of well plates containing worms and taken every hour for 24 hours.

It was tested on Windows 10.

## Usage

(*This software assumes that the wells have been already scanned and these images are stored in an images folder*)

- Clone this repo

  ```bash
  git clone https://github.com/ukalwa/track-worms-using-scanner.git
  cd track-worms-using-scanner
  ```

- Open Matlab and navigate to this cloned repo
- To record worm positions, please run `Matlab/Image_Analysis.m` and select the images folder in the GUI
- To calculate and plot the percent movement of the worms, please run `Matlab/Motility_Analysis.m`

## License

This code is GNU GENERAL PUBLIC LICENSED.

## Contributing

If you have any suggestions or identified bugs please feel free to post
them!

  [Matlab]: https://www.mathworks.com/downloads/
  [meanthresh]: https://www.mathworks.com/matlabcentral/fileexchange/41787-meanthresh-local-image-thresholding?focused=3783566&tab=function
  [paper]: https://doi.org/10.1094/PHYTO-10-17-0339-R
