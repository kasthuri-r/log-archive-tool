# Log Archive Tool

A simple command-line tool to compress `.log` files older than a specified number of days into a `.tar.gz` archive. Helps keep your system clean while storing logs for future reference.

---

## Features

- Accepts a log directory path and number of days as arguments
- Compresses old `.log` files into `tar.gz` archives
- Archives named with date & time
- Logs every archive operation
- Asks whether to delete original `.log` files
- Optionally deletes old archives interactively

---

## Usage

```bash
./log-archive.sh <log-directory> <archive-directory> <days-old>

---

**project URL**:[roadmap.sh](https://roadmap.sh/projects/log-archive-tool)

---

