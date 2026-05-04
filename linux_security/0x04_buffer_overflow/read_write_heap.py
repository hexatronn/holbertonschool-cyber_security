#!/usr/bin/python3
"""
Locates and replaces a string in the heap of a running process.
"""

import sys

def print_usage_and_exit():
    print("Usage: read_write_heap.py pid search_string replace_string")
    sys.exit(1)

def main():
    if len(sys.argv) != 4:
        print_usage_and_exit()

    pid = sys.argv[1]
    search_string = sys.argv[2]
    replace_string = sys.argv[3]

    maps_filename = f"/proc/{pid}/maps"
    mem_filename = f"/proc/{pid}/mem"

    heap_start = None
    heap_end = None

    try:
        with open(maps_filename, 'r') as maps_file:
            for line in maps_file:
                if '[heap]' in line:
                    address_range = line.split(' ')[0]
                    start_str, end_str = address_range.split('-')
                    heap_start = int(start_str, 16)
                    heap_end = int(end_str, 16)
                    print(f"[*] Found [heap]: {start_str} - {end_str}")
                    break
    except Exception as e:
        print(f"[ERROR] Can't open or parse {maps_filename}: {e}")
        sys.exit(1)

    if heap_start is None:
        print("[ERROR] Could not locate [heap] in the maps file.")
        sys.exit(1)

    search_bytes = search_string.encode('ascii')
    replace_bytes = replace_string.encode('ascii') + b'\x00'

    try:
        with open(mem_filename, 'rb+') as mem_file:
            mem_file.seek(heap_start)
            heap_data = mem_file.read(heap_end - heap_start)
            offset = heap_data.find(search_bytes)

            if offset == -1:
                print(f"[ERROR] String '{search_string}' not found in the heap.")
                sys.exit(1)

            print(f"[*] Found '{search_string}' at offset {hex(offset)}")
            
            target_address = heap_start + offset
            print(f"[*] Writing '{replace_string}' to {hex(target_address)}")
            
            mem_file.seek(target_address)
            mem_file.write(replace_bytes)
            
            print("[*] Write successful.")

    except PermissionError:
        print(f"[ERROR] Permission denied")
        sys.exit(1)
    except Exception as e:
        print(f"[ERROR] Can't read/write {mem_filename}: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
