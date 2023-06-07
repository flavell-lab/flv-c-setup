##### src dir
date_str=$(date +'%Y-%m-%d')
path_dir_src=/home/$USER/src
path_dir_src_temp=/home/$USER/setup-src-$date_str

##### .bashrc
# CUDA
if grep -Fq ">>> flv - CUDA >>>" ~/.bashrc
then
echo "CUDA path already added"
else
echo "# >>> flv - CUDA >>>
export CUDA_HOME=/usr/local/cuda
export LD_LIBRARY_PATH=${CUDA_HOME}/lib64
export PATH=${CUDA_HOME}/bin:${PATH}
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda/extras/CUPTI/lib64
# <<< flv - CUDA <<<" >> ~/.bashrc
fi

# LD_LIBRARY_PATH
if grep -Fq ">>> flv - LD_LIBRARY_PATH >>>" ~/.bashrc
then
echo "LD_LIBRARY_PATH path already added"
else
echo "# >>> flv - LD_LIBRARY_PATH >>>
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export LD_LIBRARY_PATH
# <<< flv - LD_LIBRARY_PATH <<<" >> ~/.bashrc
fi

#### julia - pycall
julia -e "import Pkg; ENV[\"PYTHON\"]=\"\";
	Pkg.add(\"PyCall\"); Pkg.build(\"PyCall\")"
julia -e "import Pkg; Pkg.add(\"PyPlot\")"

#### python package
# activate julia conda
. ~/.julia/conda/3/x86_64/bin/activate

# update conda
conda update --all

# torch
pip install torch torchvision torchaudio

# py - unet2d
mkdir -p $path_dir_src_temp
cd $path_dir_src_temp
rm -rf $path_dir_src_temp/unet2d
git clone git@github.com:flavell-lab/unet2d.git
cd $path_dir_src_temp/unet2d
git checkout v0.1
pip install .

# py - pytorch-3dunet
pip install nd2reader hdbscan tensorboard tensorboardX h5py simpleitk
cd $path_dir_src
rm -rf $path_dir_src/pytorch-3dunet
git clone git@github.com:flavell-lab/pytorch-3dunet
cd $path_dir_src/pytorch-3dunet
pip install .

#### julia packages
julia -e "import Pkg; pkg = Pkg.PackageSpec(name=\"FlavellPkg\", url=\"git@github.com:flavell-lab/FlavellPkg.jl.git\"); Pkg.add(pkg)"
julia -e "using FlavellPkg; FlavellPkg.install_default();"
julia -e "using FlavellPkg; FlavellPkg.install_imaging(false);"
julia -e "using FlavellPkg; FlavellPkg.install_CePNEM(false);"

# precompile packages
julia -e "using Pkg; Pkg.instantiate(); Pkg.precompile();"

# install kernel
julia -e "using IJulia; IJulia.installkernel(\"Julia\")"

#### misc
# set up lock directory
mkdir -p ~/lock

# remove temp src dir
rm -rf $path_dir_src_temp
rm /tmp/installer.sh

