# Introduction

This is a script, config, etc that I have put together for me to restore my k1 after a factory reset, this is NOT something anyone else should use, as k1 sometimes use different chips in MCUs and so this would cause issues for your printer.

Also if this falls over half way it could soft brick one or more of your MCUs if you are not careful

DO NOT USE THIS SCRIPT

The config might be of use as a reference though.

# Installation

```
cd ~
git config --global http.sslVerify false
git clone https://github.com/pellcorp/printers.git
cd printers/k1
./install.sh
```

The Bltouch model I use:

https://www.printables.com/model/666186-creality-k1-bltouch-adapter

