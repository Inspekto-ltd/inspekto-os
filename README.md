# inspekto-os

## build one of the following docker images (on linux machine)

```bash
docker build -t inspekto-os -f inspekto-os-cuda11_8-ubuntu22.Dockerfile .
docker build -t inspekto-os -f inspekto-os-cuda12_2-ubuntu22.Dockerfile .
# to build inspekto-os-debian-bookworm-slim we need to also build debian-bookworm-slim-39095b9
docker build -t debian:bookworm-slim-39095b9 ./debian-bookworm-slim-39095b9
docker build -t inspekto-os -f inspekto-os-debian-bookworm-slim.Dockerfile .
```

## licenses

### base images

- nvidia/cuda:11.8.0-devel-ubuntu22.04

  <https://developer.download.nvidia.com/compute/cuda/opensource/image/11.8.0/nvidia-cuda-11.8.0-base-ubuntu22.04-x86_64-sha256-6b994a83ff50c8034618a79e9d6c016ec4253fae5798b1bad03c27ec8720066c.tgz>

- nvidia/cuda:12.2.2-cudnn8-devel-ubuntu22.04

  <https://developer.download.nvidia.com/compute/cuda/opensource/image/12.2.2/nvidia-cuda-12.2.2-base-ubuntu22.04-x86_64-sha256-f2c3ae91f29cd8e5cc9e13834398405b2d8af1c979e5cfebb577daf28e436585.tgz>

- debian-bookworm-slim-39095b9

  built locally using rootfs.tar.xz from (wget)

  <https://github.com/debuerreotype/docker-debian-artifacts/raw/39095b9bf8cbb2635be1e2dfed3d152f0b3d72bf/bookworm/slim/rootfs.tar.xz>

### inspekto-os deb packages

All deb licenses are in licenses/deb-licenses folder
Will also be inside the image at /inspekto_nvm/lib/licenses

The following is a list of all deb packages installed in inspekto-os image

For adding a missing license - we go into the docker images,
do `apt-cache show xclip` for example, find the homepage and search for license

```bash
wget
sudo
git
curl
unzip
net-tools
network-manager
jq
vim
xclip
udev
tzdata
cmake
apt-utils
lsb-release
lsb-core or lsb-base
libhdf5-dev
python3-gst-1.0
libgeos-dev
libgirepository1.0-dev
libcairo2-dev
pkg-config
gir1.2-gtk-3.0
libgstreamer1.0-0
gstreamer1.0-tools
gstreamer1.0-plugins-base
gstreamer1.0-plugins-good
gstreamer1.0-plugins-bad
gstreamer1.0-plugins-ugly
libxml2
libzip-dev
libglib2.0-0
libgirepository-1.0-1
libudev1
libusb-1.0-0
libuuid1
libpcap0.8
qtgstreamer-plugins-qt5
python3-pyqt5
python3-gi
libcap-dev
libzmq3-dev
ethtool
isc-dhcp-server
ntfs-3g
zip
gcc-12
g++-12
google-perftools
libaravis-dev
libmkl-dev
libtbb2-dev
```

### inspekto-os other packages

All other licenses are in licenses/other-licenses folder
Will also be inside the image at /inspekto_nvm/lib/licenses

The following is a list of all other installed in inspekto-os image

```bash
tiscamera
mongo-database-tools
python
```

### inspekto-os python packages

All python licenses are in licenses/python-licenses folder and licenses/python-manual-licenses
Will also be inside the image at /inspekto_nvm/lib/licenses

We can generate licenses using licenses/prepare_python_licenses.py for a virtualenv.
The following is a list of all python packages installed in inspekto-os image
Tabbed licenses are auto generated and are in python-licenses.
? before are missing

```bash
root@51b716ca1118:/tinybox# pip freeze
absl-py==1.4.0
anyio==3.7.1
asciitree==0.3.3
astunparse==1.6.3
bcrypt==4.0.1
bidict==0.22.1
bitstring==4.0.2
bleach==6.0.0
blinker==1.6.2
blosc2==2.0.0
Brotli==1.0.9
bson==0.5.10
cachetools==5.3.1
certifi==2023.7.22
cffi==1.15.1
charset-normalizer==3.2.0
click==8.1.6
contourpy==1.1.0
cryptography==41.0.3
cycler==0.11.0
Cython==0.29.36
dnspython==2.4.1
docutils==0.20.1
einops==0.8.0
email-validator==2.0.0.post2
entrypoints==0.4
fastapi==0.101.0
fasteners==0.18
faster-fifo==1.4.5
filelock==3.13.1
Flask==2.3.2
Flask-Cors==4.0.0
Flask-SocketIO==5.3.5
Flask-Sockets==0.2.1
flatbuffers==23.5.26
fonttools==4.42.0
fsspec==2024.2.0
gast==0.4.0
gevent==23.7.0
gevent-websocket==0.10.1
gitdb==4.0.10
GitPython==3.1.32
google-auth==2.22.0
google-auth-oauthlib==1.0.0
google-pasta==0.2.0
GPUtil==1.4.0
greenlet==2.0.2
h11==0.14.0
h5py==3.9.0
hdbscan==0.8.33
idna==3.4
imageio==2.31.1
importlib-metadata==6.7.0
inflate64==0.3.1
intel_extension_for_pytorch==2.3.100
itsdangerous==2.1.2
jaraco.classes==3.2.3
jeepney==0.8.0
Jinja2==3.1.2
joblib==1.3.1
keras==2.15.0
keyring==24.2.0
kiwisolver==1.4.4
kornia==0.7.3
kornia_rs==0.1.5
lazy_loader==0.3
libclang==16.0.6
llvmlite==0.42.0
Markdown==3.4.4
markdown-it-py==3.0.0
MarkupSafe==2.1.3
matplotlib==3.7.2
mdurl==0.1.2
ml-dtypes==0.2.0
mongoengine==0.27.0
more-itertools==9.1.0
mpmath==1.3.0
msgpack==1.0.5
multivolumefile==0.2.3
netifaces==0.11.0
networkx==3.1
nmcli==1.2.0
numba==0.59.0
numcodecs==0.11.0
numexpr==2.8.4
numpy==1.26.4
oauthlib==3.2.2
opt-einsum==3.3.0
packaging==23.1
pandas==2.0.3
paramiko==3.4.0
Phidget22==1.16.20230707
Pillow==10.0.0
pkgconfig==1.5.5
pkginfo==1.9.6
protobuf==4.23.4
psutil==5.9.5
py-cpuinfo==9.0.0
py7zr==0.20.6
pyasn1==0.5.0
pyasn1-modules==0.3.0
pybase64==1.2.3
pybcj==1.0.1
pycairo==1.24.0
pycparser==2.21
pycryptodomex==3.18.0
pydantic==1.10.12
pydensecrf @ git+https://github.com/lucasb-eyer/pydensecrf.git@0d53acbcf5123d4c88040fe68fbb9805fc5b2fb9
pyee==11.0.0
Pygments==2.15.1
PyGObject==3.44.1
pymodbus==2.3.0
pymongo==4.4.0
Pympler==1.0.1
PyNaCl==1.5.0
pyod==1.1.0
pyotp==2.9.0
pyparsing==3.0.9
pyppmd==1.0.0
pyserial==3.5
pytelegraf==0.3.3
python-dateutil==2.8.2
python-dotenv==1.0.0
python-engineio==4.5.1
python-gnupg==0.5.1
python-socketio==5.8.0
pytz==2023.3
pyudev==0.24.1
PyWavelets==1.4.1
pyzbar==0.1.9
pyzmq==25.1.0
pyzstd==0.15.9
readme-renderer==40.0
requests==2.31.0
requests-oauthlib==1.3.1
requests-toolbelt==1.0.0
rfc3986==2.0.0
rich==13.4.2
rsa==4.9
scikit-image==0.21.0
scikit-learn==1.3.0
scipy==1.11.1
SecretStorage==3.3.3
segment-anything==1.0
setproctitle==1.3.2
sh==2.0.4
shapely==2.0.4
six==1.16.0
smmap==5.0.0
sniffio==1.3.0
starlette==0.27.0
sympy==1.12
tables==3.8.0
tensorboard==2.15.2
tensorboard-data-server==0.7.1
tensorflow-estimator==2.15.0
tensorflow-io-gcs-filesystem==0.33.0
termcolor==2.3.0
texttable==1.6.7
threadpoolctl==3.2.0
tifffile==2023.7.18
torch==2.3.1+cpu
torchaudio==2.3.1+cpu
torchvision==0.18.1+cpu
tornado==6.3.2
tqdm==4.65.0
twine==4.0.2
typeguard==2.13.3
typing_extensions==4.9.0
tzdata==2023.3
tzlocal==5.0.1
ujson==5.8.0
urllib3==1.26.16
uvicorn==0.23.2
webencodings==0.5.1
Werkzeug==2.3.6
wrapt==1.14.1
WTForms==3.0.1
xxhash==3.3.0
zarr==2.16.0
zipp==3.15.0
zope.event==5.0
zope.interface==6.0
```
