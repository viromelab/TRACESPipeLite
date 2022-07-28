#!/bin/bash
#
lzma -k -d VDB.mfa.lzma;
#
./TRACESPipeLite.sh --reads1 reads_forward.fq.gz --reads2 reads_reverse.fq.gz --database VDB.mfa --output lite_viral_analysis --threads 4
#
