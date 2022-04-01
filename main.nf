#!/usr/bin/env nextflow

nextflow.enable.dsl=2

 /* 
 EMIRGE pipeline implemented with Nextflow
 
 Authors:
 - Katie Lennard <katieviljoen@gmail.com>
 */
 
 
 /*
========================================================================================
    READS AND REFERENCE DB PARAMETER VALUES
========================================================================================
*/

params.reads = "$baseDir/*_{1,2}*.fastq"
params.DB = "$baseDir/SILVA_138.1_SSURef_NR99_tax_silva_trunc.ge1200bp.le2000bp.0.97.fixed.fasta"
params.index = "$baseDir/SILVA_138.1_SSURef_NR99_tax_silva_trunc.ge1200bp.le2000bp.0.97.fixed.btindex"
params.outdir = "$baseDir/emirge_results"
params.emirge_final = "$baseDir/emirge_results/iter.40"

 
 log.info """\
 EMIRGE  P I P E L I N E
 ===================================
 reads        : ${params.reads}
 DB           : ${params.DB}
 outdir       : ${params.outdir}
 """
 
 
 def helpMessage() {
    log.info"""
    ===================================
     ${workflow.repository}/EMIRGE_nextflow  ~  version ${params.version}
    ===================================
    Usage:
    The typical example for running the pipeline with command line flags is as follows:
    nextflow run kviljoen/EMIRGE_nextflow --reads '*_R{1,2}.fastq' emirge_amplicon.py --reference SILVA_138.1_SSURef_NR99_tax_silva_trunc.ge1200bp.le2000bp.0.97.fixed.fasta 
    --bt_index SILVA_138.1_SSURef_NR99_tax_silva_trunc.ge1200bp.le2000bp.0.97.fixed.btindex 
    --insert_size 500 --max_len 500 -insert_sd 500 --phred 33 -profile ilifu
    
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
    """.stripIndent()
}
 
 
process emirge {
publishDir params.outdir, mode:'copy'

    input:
      tuple val(pair_id), path(reads)
    output:
      tuple val(pair_id), path(outdir)
    script:
      """
      emirge_amplicon.py ${outdir} -1 ${pair_id.get(0)} -2 ${pair_id.get(1)} -f ${params.reference} -b ${params.btindex} -i ${params.insert_size} 
      -l ${params.max_len} -s {$params.insert_sd} --phred33 &> emirge_amplicon_std_out_err
      """
}

process rename_fasta {
publishDir params.outdir, mode:'copy'

    input:
      path(emirge_final)
    output:
      file('renamed.fasta')
    script:
      """
      emirge_rename_fasta.py ${emirge_final} > emirge_renamed.fasta  &> emirge_rename_std_out_err
      """

}

/*
 * main flow
 */
read_pairs = Channel.fromFilePairs( params.reads, checkIfExists: true )

workflow {
    emirge(params.reference, params.btindex, read_pairs, params.insert_size, params.max_len, params.insert_sd, params.phred)
    rename_fasta(emirge_final)
}

