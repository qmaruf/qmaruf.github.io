---
layout: post
title: PyTorch Stopped Working After a Kernel Upgrade? Here's the Fix
date: 2026-02-18
---

If you updated your Linux system recently and suddenly PyTorch refuses to import with this error:

```
ImportError: libtorch_cpu.so: cannot enable executable stack as shared object requires: Invalid argument
```

You are not alone. This is a known compatibility issue between newer Linux kernels (6.x and above) and older PyTorch builds. Here is what is going on and how to fix it in two minutes.

---

## What Is Happening?

When a shared library (a `.so` file) is compiled, it carries a small flag that tells the operating system what kind of memory permissions it needs. One of those flags is called `PT_GNU_STACK`. It can be set to `RW` (read and write) or `RWE` (read, write, and execute).

Older versions of PyTorch — including the widely used 1.x releases — shipped `libtorch_cpu.so` with the stack marked as **executable** (`RWE`). This was never great from a security standpoint, but older Linux kernels quietly allowed it.

Linux kernel 6.x changed that. It now **strictly refuses** to load any shared library that asks for an executable stack. When Python tries to import PyTorch, the kernel sees that flag, rejects the library, and you get the `Invalid argument` error above.

Your PyTorch installation did not break. Your kernel got stricter. The `.so` file just has a flag that needs to be cleared.

---

## The Fix

You need a tool called `patchelf`. It can edit ELF binary files (the format Linux uses for executables and libraries) without recompiling anything.

**Step 1 — Install patchelf**

On Fedora / RHEL:
```bash
sudo dnf install patchelf
```

On Ubuntu / Debian:
```bash
sudo apt install patchelf
```

**Step 2 — Clear the executable stack flag**

Point it at the offending file inside your virtual environment:

```bash
patchelf --clear-execstack .venv/lib/python3.9/site-packages/torch/lib/libtorch_cpu.so
```

Adjust the path to match your Python version and virtual environment location.

**Step 3 — Verify it works**

```bash
python -c "import torch; print(torch.__version__)"
```

That should now print your PyTorch version without any errors.

---

## Why Not Just Use `execstack`?

There is another tool called `execstack` that does a similar job. However, `libtorch_cpu.so` is a very large file with an unusual internal layout — its sections are not stored in the standard order. `execstack` gets confused by this and exits with an error. `patchelf` handles it without complaints.

---

## Will This Break Anything?

No. The executable stack flag was almost certainly set by accident during PyTorch's build process, not because the library actually needs an executable stack to function. Clearing the flag tells the kernel "this library does not need to execute code from the stack," which is the correct and more secure behavior. PyTorch works perfectly fine after the change.

---

## One Thing to Keep in Mind

This is a change to the installed file on disk. If you recreate your virtual environment or reinstall PyTorch, you will need to run the `patchelf` command again. You could add it as a post-install step in your setup script to avoid surprises.

---

Newer PyTorch releases (2.x and above) have already fixed this in their build pipeline, so if you are able to upgrade, that is the cleanest long-term solution. But if you are stuck on an older version for compatibility reasons, `patchelf` gets you running again in seconds.
