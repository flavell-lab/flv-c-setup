### ADD to or DELETE from this list to reflect the exact private python packages you would like to update
repos="euler_gpu DeepReg autolabel" 

date_str=$(date +'%Y-%m-%d')
path_dir_src_temp=/home/$USER/setup-src-$date_str
 
# activate julia conda
. ~/.julia/conda/3/x86_64/bin/activate

# update conda
conda update --all -y
mkdir -p $path_dir_src_temp
for repo in $repos; do
    cd $path_dir_src_temp
    rm -rf "$path_dir_src_temp/$repo"  # Remove the existing repository directory, if it exists
    git clone "git@github.com:flavell-lab/$repo.git" "$path_dir_src_temp/$repo"
    cd "$path_dir_src_temp/$repo" 
    pip install .
done

# remove temp src dir
rm -rf $path_dir_src_temp
