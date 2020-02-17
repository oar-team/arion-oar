Arion OAR
============

Arion OAR allows to setup mini OAR cluster based on docker containers and [NixOS](https://nixos.org/nixos/) in different flavors. In spirit, it's equivalent to [oar-docker](http://oar.imag.fr/wiki:oar-docker) but based on [Nix/Nixos](https://nixos.org/) ecosystem.

# Requirements:
- Machine with [Nixos](https://nixos.org/) 
- A modified version of [Arion](https://github.com/hercules-ci/arion): [there](https://github.com/oar-team/arion)
```sh
nix-env -iA arion -f https://github.com/oar-team/arion/tarball/master
```

# Installation:
Not a real installation just take the source:
```sh
git clone git@github.com:oar-team/arion-oar.git
cd arion-oar
```
# Flavors and use:
Several flavors are proposed:
 - **Basic**: OAR cluster with a frontend, a server and two nodes.
 - **Simple**: OAR cluster with a frontend, a server and two nodes, with drawgantt and monika.
 - **Full**:  OAR cluster as _simple_ one with _Colmet_ monitoring service (**WIP**).
 - **CiGri**: Lightweight Grid with 2 OAR clusters.

```sh
# below, replace <FLAVOR> by your choice, e.g. basic
cd <FLAVOR>
arion up
#In other terminal
cd <FLAVOR> 
arion exec frontend bash
#Now submit an interactive job (Ctrl-D to terminate)
oarsub -I
```
To stop containers
```sh
arion down
```

# Misc:
## Cgroups cleaning
To allow cgroups support a new hierarchy (/sys/fs/cgroup/oardocker) and links are automatically created to remove them launch the follow command
```sh
./clean_cgroup.sh
```
## Tips:
Speedup login (arion exec frontend bash) into specific container by scanning active container instead of reevalute Nix expression.

```sh
# To add to .bashrc or other shell startup file 
function docka() {docker exec -it $(docker ps -qf "name=.*$1.*") bash;}
# Use
docka frontend
```
