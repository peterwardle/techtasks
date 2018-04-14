#!/usr/bin/env python
import sys
import os
import argparse

class Logrotate:
    def __init__(self, dir, buffer=10, min_entries=1, debug=False):
        if not os.path.isdir(dir):
            raise ValueError("`%s` does not exist or is not a directory" % dir)
        if buffer <= 0 or buffer > 100:
            raise ValueError("Buffer must be greater than 0 and less than 100 percent")

        self.debug = debug
        self.dir = dir
        self.buffer = (buffer * 1.0) / 100
        self.min_entries = min_entries
        self.files = self.listFilesByCreationTime()

        if self.debug:
            print "dir:", self.dir
            print "buffer:", self.buffer
            print "min_entries:", self.min_entries
            print "files:", self.files

    def shouldRemoveOldestEntry(self):
        if len(self.files) <= self.min_entries:
            return False

        statvfs = os.statvfs(self.dir)
        freebytes = statvfs.f_bavail * statvfs.f_frsize
        bufferbytes = statvfs.f_blocks * statvfs.f_frsize * self.buffer

        return freebytes < bufferbytes

    def listFilesByCreationTime(self):
        files = [os.path.join(self.dir, f) for f in os.listdir(self.dir)]
        return sorted(files, key=os.path.getctime)

    def getOldestEntry(self):
        return self.files[0]

    def removeOldestEntry(self):
        file = self.getOldestEntry()

        if self.debug:
            print "Removing logfile:", file
            return None

        os.remove(file)
        return file

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Cleanup logs based on available system resources')
    parser.add_argument('dir', help='directory of logs to manage')
    parser.add_argument('--debug', action='store_true', help='toggle debug mode')
    parser.add_argument('--min', default=1, type=int, help='the minumum number of log entries to keep')
    parser.add_argument('--buffer', default=10, type=int, help='the percentage of storage capacity to maintain')

    args = parser.parse_args()

    try:
        logrotate = Logrotate(args.dir, args.buffer, args.min, args.debug)
    except ValueError as error:
        print "ERROR: ", repr(error)
        print usage()
        sys.exit(1)

    if logrotate.shouldRemoveOldestEntry():
        print "Removed logfile: %s" % logrotate.removeOldestEntry()
