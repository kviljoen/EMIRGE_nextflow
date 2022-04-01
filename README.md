# EMIRGE_nextflow
A Nextflow implementation of EMIRGE (emirge_amplicon.py) to run samples in parallel. EMIRGE reconstructs full length ribosomal genes from short read
sequencing data.  In the process, it also provides estimates of the sequences' abundances.

## Basic usage:
    Usage:
    This pipeline can be run specifying parameters in a config file or with command line flags.
    
    To override existing values from the command line, please type these parameters:
    
    Mandatory arguments:
      --reads                       Path to input data (must be surrounded with quotes)
      -profile                      Hardware config to use. Current profile available for Ilifu 'ilifu' - create your own if necessary
                                    NB -profile should always be specified on the command line, not in the config file
      --reference                   Path to 16S taxonomic database to be used for annotation (SILVA_138.1_SSURef_NR99_tax_silva_trunc.ge1200bp.le2000bp.0.97.fixed.fasta). Note that this 
                                    DB should already have been prepared as described https://github.com/jgolob/EMIRGE
      --btindex                     Indexed 16S DB (SILVA_138.1_SSURef_NR99_tax_silva_trunc.ge1200bp.le2000bp.0.97.fixed.btindex ) already prepared from the DB specified in --reference as described https://github.com/jgolob/EMIRGE
      --max_len                     integer. Max read length
      --insert_size                 integer. Insert size distribution mean ( base 1 of read 1 to base 1 of read 2 )
      --insert_sd                   integer. size distribution standard deviation
    
    Optional EMIRGE parameters:
      --phred                       {33, 64}. EMIRGE assumes that fastq quality scores are Phred+64; most new projects are now Phred+33
      --iterations                  integer. Default = 40, but it may be necessary to increase this for more complex samples                                       
  
    Other arguments:
      --outdir                      The output directory where the results will be saved
      --email                       Set this parameter to your e-mail address to get a summary e-mail with details of the run                                     
                                    sent to you when the workflow exits
      -name                         Name for the pipeline run. If not specified, Nextflow will automatically generate a random mnemonic.
    
     Help:
      --help                        Will print out summary above when executing nextflow run kviljoen/EMIRGE_nextflow
                                  
     Example run:
     To run on Ilifu
     1) Start a 'screen' session from the headnode
     2) A typical command would look something like: 
     nextflow run kviljoen/EMIRGE_nextflow --reads '*_R{1,2}.fastq' --reference ILVA_138.1_SSURef_NR99_tax_silva_trunc.ge1200bp.le2000bp.0.97.fixed.fasta 
    --bt_index SILVA_138.1_SSURef_NR99_tax_silva_trunc.ge1200bp.le2000bp.0.97.fixed.btindex 
    --insert_size 500 --max_len 500 --insert_sd 500 --phred 33 -profile ilifu


## Prerequisites

Nextflow, EMIRGE and all it's dependencies (https://github.com/jgolob/EMIRGE)
Note: if you are working on Ilifu you can simply use the singularity image specified in the Ilifu profile 

## Documentation
The kviljoen/EMIRGE_nextflow pipeline comes with documentation about the pipeline, found in the `docs/` directory:

1. [Installation](docs/installation.md)
2. [Running the pipeline](docs/usage.md)

## Built With

* [Nextflow](https://www.nextflow.io/)
* [Docker](https://www.docker.com/what-docker)
* [Singularity](https://singularity.lbl.gov/)


## Credits

EMIRGE software (https://github.com/csmiller/EMIRGE). Please remember to cite the authors of EMIRGE when using this pipeline:

Miller CS, Baker BJ, Thomas BC, Singer SW, Banfield JF (2011) EMIRGE: reconstruction of full-length ribosomal genes from microbial community short read sequencing data. Genome biology 12: R44. doi:10.1186/gb-2011-12-5-r44.

Miller CS, Handley KM, Wrighton KC, Frischkorn KR, Thomas BC, Banfield JF (2013) Short-Read Assembly of Full-Length 16S Amplicons Reveals Bacterial Diversity in Subsurface Sediments. PloS one 8: e56018. doi:10.1371/journal.pone.0056018.

Docker container: https://github.com/jgolob/EMIRGE

The pipeline was implemented in Nextflow by Dr Katie Lennard from the Institute of Infectious Disease and Molecular Medicine, University of Cape Town

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
