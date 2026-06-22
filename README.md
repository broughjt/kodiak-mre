MacOS:

On my work Mac with 36G RAM, the `mre` jumps up to full RAM usage and 36G swap space before getting killed by the system.

```bash
cmake --preset dev
cmake --build --preset dev
./build/dev/mre
```

Linux:

The last command gets OOM killed on my laptop after growing its mapped virtual memory address space to 18G or so.

```bash
cmake --preset dev
cmake --build --preset dev
systemd-run --user --scope -p MemoryMax=6G ./build/dev/mre
```

