#!/usr/bin/env python

import csv
import os
import sys


def determine_dialect(file):
    try:
        result = csv.Sniffer().sniff(file.read(1024))
        file.seek(0)
        return result
    except:
        file.seek(0)
        return csv.get_dialect('excel')


def main(argv):
    csv_file_name = argv[0] if len(argv) > 0 else None
    if not csv_file_name:
        print 'Please provide a csv file as argument.'
        print ''
        print "        %s [csv-file]" % os.path.basename(__file__)
        print ''
        sys.exit(1)

    if not os.path.isfile(csv_file_name):
        print "The CSV file '%s' does not exist." % csv_file_name
        sys.exit(1)

    with open(csv_file_name, 'rb') as csv_file:
        csv_reader = csv.reader(csv_file, determine_dialect(csv_file))

        header_row = csv_reader.next()
        if header_row:
            print("||%s||" % ('||'.join(header_row)))

        for row in csv_reader:
            print("|%s|" % ('|'.join(row)))

if __name__ == "__main__":
    main(sys.argv[1:])
