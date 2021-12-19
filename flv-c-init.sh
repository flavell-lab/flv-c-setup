# .bashrc
echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export LD_LIBRARY_PATH
# >>> CUDA >>>
export CUDA_HOME=/usr/local/cuda
export LD_LIBRARY_PATH=${CUDA_HOME}/lib64
PATH=${CUDA_HOME}/bin:${PATH}
export PATH
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}/usr/local/cuda/extras/CUPTI/lib64
# <<< CUDA <<<" >> ~/.bashrc

julia -e "import Pkg; ENV[\"PYTHON\"]=\"\";
	Pkg.add(\"PyCall\"); Pkg.build(\"PyCall\")"
julia -e "import Pkg; Pkg.add(\"PyPlot\")"

# activate julia conda
. ~/.julia/conda/3/bin/activate

# torch
pip install torch==1.8.2+cu111 torchvision==0.9.2+cu111 torchaudio==0.8.2 -f https://download.pytorch.org/whl/lts/1.8/torch_lts.html

# src dir
date_str=$(date +'%Y-%m-%d')
path_dir_src=/home/$USER/setup-src-$date_str

# unet2d
mkdir -p $path_dir_src
cd $path_dir_src
rm -rf $path_dir_src/unet2d
git clone git@github.com:flavell-lab/unet2d.git
cd $path_dir_src/unet2d
git checkout develop
pip install .

# pytorch-3dunet
pip install nd2reader hdbscan tensorboard tensorboardX h5py simpleitk
cd $path_dir_src
rm -rf $path_dir_src/pytorch-3dunet
git clone git@github.com:flavell-lab/pytorch-3dunet
cd $path_dir_src/pytorch-3dunet
git checkout develop
pip install .

# other packages
julia -e "import Pkg; pkg = Pkg.PackageSpec(name=\"FlavellPkg\", url=\"git@github.com:flavell-lab/FlavellPkg.jl.git\", rev=\"develop\"); Pkg.add(pkg)"
julia -e "using FlavellPkg; FlavellPkg.install_default(); FlavellPkg.install_imaging(true);"

# set up lock directory
mkdir -p ~/lock

# remove temp src dir
rm -rf $path_dir_src

# change default conda env to Julia conda
~/.julia/conda/3/bin/conda init bash
