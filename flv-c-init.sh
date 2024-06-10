#!/bin/bash

##### src dir
date_str=$(date +'%Y-%m-%d')
path_dir_src=/home/$USER/src
path_dir_src_temp=/home/$USER/setup-src-$date_str

#### julia - pycall
julia -e "import Pkg; ENV[\"PYTHON\"]=\"\";
	Pkg.add(\"PyCall\"); Pkg.build(\"PyCall\")"
 
#### python package
# activate julia conda
. ~/.julia/conda/3/x86_64/bin/activate

# update conda
conda update --all -y

# public py libraries - torch, tensorflow, cuda
pip install torch torchvision torchaudio 
python3 -m pip install tensorflow==2.15
python3 -m pip install cuda

# private fork of public library - deepreg
# private py packages - unet2d, euler_gpu, autolabel
# src code will be erased from home directory after installation
declare -a repos=(unet2d euler_gpu DeepReg autolabel)
mkdir -p $path_dir_src_temp
for repo in "${repos[@]}"; do
    cd $path_dir_src_temp
    rm -rf $path_dir_src_temp/$repo  # Remove the existing repository directory, if it exists
    git clone git@github.com:flavell-lab/$repo.git
    cd $path_dir_src_temp/$repo    
    if [ $repo == unet2d ]; then  # For 'unet2d', checkout a specific version
        git checkout v0.1
    fi
    pip install .
done

# private py package - pytorch-3dunet, src code will remain in home directory after installation
pip install matplotlib nd2reader hdbscan tensorboard tensorboardX h5py simpleitk pyyaml
cd $path_dir_src
rm -rf $path_dir_src/pytorch-3dunet
git clone git@github.com:flavell-lab/pytorch-3dunet
cd $path_dir_src/pytorch-3dunet
pip install .

#### julia packages
julia -e "import Pkg; Pkg.add(\"PyPlot\")" # pyplot
julia -e "import Pkg; pkg = Pkg.PackageSpec(name=\"FlavellPkg\", url=\"git@github.com:flavell-lab/FlavellPkg.jl.git\"); Pkg.add(pkg)"
julia -e "using Pkg; pkg = Pkg.PackageSpec(name=\"FlavellPkg\", url=\"git@github.com:flavell-lab/FlavellPkg.jl.git\", rev=\"dev\"); Pkg.add(pkg)" #temporary
julia -e "using FlavellPkg; FlavellPkg.install_default();"
julia -e "using FlavellPkg; FlavellPkg.install_ANTSUN(false);"
julia -e "using FlavellPkg; FlavellPkg.install_CePNEM(false);"

# precompile packages
julia -e "using Pkg; Pkg.instantiate(); Pkg.precompile();"

# install kernel
julia -e "using IJulia; IJulia.installkernel(\"Julia\")"

# remove temp src dir
rm -rf $path_dir_src_temp
rm /tmp/installer.sh
