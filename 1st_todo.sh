# get all dot files
cd ~/
git init
git clone https://github.com/quydau35/dotfile.git

# install JAVA
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get updates
sudo apt-get install oracle-java9-installer oracle-java9-set-default

# install texlive 2015, assuming you had all the binary files in ~/.texlive2015
sudo apt-get install libgtk2-perl perl-tk perl xzdec
cd ~/.texlive2015/ && sudo ./install-tl -gui wizard

# install AMBERTOOL, assuming you had all the binary files in ~/.amber14
sudo apt-get install flex bison tcsh gfortran g++ xorg-dev libbz2-dev libopenmpi-dev openmpi-bin python-tk python-dev python-matplotlib python-numpy python-scipy libtool patch gnuplot ssh csh
export AMBERHOME='/home/quyngan/.amber14'
cd ~/.amber14
./configure -openmp gnu
make install

# install ViLAS
sudo apt-get install pip pymol avogadro grace openbabel gromacs 
