##### src dir
date_str=$(date +'%Y-%m-%d')
path_dir_src=/home/$USER/src
path_dir_src_temp=/home/$USER/setup-src-$date_str

#### julia - build pycall
julia -e "import Pkg; ENV[\"PYTHON\"]=\"\";
	Pkg.add(\"PyCall\"); Pkg.build(\"PyCall\")"
 
#### python package
# activate julia conda
. ~/.julia/conda/3/x86_64/bin/activate

# update conda
conda update --all -y

# install Python 3.10 for compatability with Tensorflow 2.15
conda install python=3.10

# public py libraries - torch, tensorflow
pip install torch torchvision torchaudio 
python3 -m pip install tensorflow==2.15

# private fork of public library - deepreg
# private py packages - unet2d, euler_gpu, autolabel
# src code will be erased from home directory after installation
repos="unet2d euler_gpu DeepReg AutoCellLabeler"
mkdir -p $path_dir_src_temp
for repo in $repos; do
    cd $path_dir_src_temp
    rm -rf "$path_dir_src_temp/$repo"  # Remove the existing repository directory, if it exists
    git clone "git@github.com:flavell-lab/$repo.git" "$path_dir_src_temp/$repo"
    cd "$path_dir_src_temp/$repo" 
    if [ "$repo" = "unet2d" ]; then
        git checkout v0.1
    fi
    pip install .
done

# private py package - pytorch-3dunet, src code will remain in home directory after installation
pip install matplotlib nd2reader hdbscan tensorboard tensorboardX h5py simpleitk pyyaml
mkdir -p $path_dir_src
cd $path_dir_src
rm -rf $path_dir_src/pytorch-3dunet
git clone git@github.com:flavell-lab/pytorch-3dunet
cd $path_dir_src/pytorch-3dunet
pip install .

#### julia packages again
julia -e "import Pkg; Pkg.add(\"PyPlot\")" # pyplot
julia -e "using Pkg; pkg = Pkg.PackageSpec(name=\"FlavellPkg\", url=\"git@github.com:flavell-lab/FlavellPkg.jl.git\"); Pkg.add(pkg)"
# julia -e "using Pkg; pkg = Pkg.PackageSpec(name=\"FlavellPkg\", url=\"git@github.com:flavell-lab/FlavellPkg.jl.git\", rev=\"dev\"); Pkg.add(pkg)" #disabled after testing and merging FlavellPkg.jl#dev
julia -e "using FlavellPkg; FlavellPkg.install_default();"
julia -e "using FlavellPkg; FlavellPkg.install_ANTSUN(false);"
julia -e "using FlavellPkg; FlavellPkg.install_CePNEM(false);"

# precompile julia packages
julia -e "using Pkg; Pkg.instantiate(); Pkg.precompile();"

# install julia kernel
julia -e "using IJulia; IJulia.installkernel(\"Julia\")"

# remove temp src dir that used to contain the py packages
rm -rf $path_dir_src_temp
rm -rf /tmp/installer.sh
