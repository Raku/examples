use v6;

=begin pod

=TITLE Generate and write random DNA sequences

=AUTHOR Daniel Carrera

Based on the submission for Perl 5.

The program should

=item generate DNA sequences, by copying from a given sequence
=item generate DNA sequences, by weighted random selection from 2 alphabets
=item convert the expected probability of selecting each nucleotide into
      cumulative probabilities
=item match a random number against those cumulative probabilities to select
      each nucleotide (use linear search or binary search)
=item use this linear congruential generator to calculate a random number
      each time a nucleotide needs to be selected (don't cache the random number
      sequence)

    IM = 139968
    IA = 3877
    IC = 29573
    Seed = 42

    Random (Max)
    Seed = (Seed * IA + IC) modulo IM
         = Max * Seed / IM

write 3 sequences line-by-line in FASTA format.

L<http://benchmarksgame.alioth.debian.org/u32/performance.php?test=fasta>

USAGE:

    perl6 fasta.p6 1000

Expected output

    >ONE Homo sapiens alu
    GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGA
    TCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACT
    AAAAATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAG
    GCTGAGGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCG
    CCACTGCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAAGGCCGGGCGCGGT
    GGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCA
    GGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATACAAAAA
    TTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAG
    AATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCA
    GCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAAGGCCGGGCGCGGTGGCTCACGCCTGT
    AATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACC
    AGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTG
    GTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACC
    CGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGGGCGACAG
    AGCGAGACTCCGTCTCAAAAAGGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTT
    TGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACA
    TGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCT
    GTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGG
    TTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTGGGCGACAGAGCGAGACTCCGT
    CTCAAAAAGGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGG
    CGGGCGGATCACCTGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCG
    TCTCTACTAAAAATACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTA
    CTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCG
    AGATCGCGCCACTGCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAAGGCCG
    GGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACC
    TGAGGTCAGGAGTTCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAA
    TACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGA
    GGCAGGAGAATCGCTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACT
    GCACTCCAGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAAGGCCGGGCGCGGTGGCTC
    ACGCCTGTAATCCCAGCACTTTGGGAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGT
    TCGAGACCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAATACAAAAATTAGC
    CGGGCGTGGTGGCGCGCGCCTGTAATCCCAGCTACTCGGGAGGCTGAGGCAGGAGAATCG
    CTTGAACCCGGGAGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCCAGCCTG
    GGCGACAGAGCGAGACTCCG
    >TWO IUB ambiguity codes
    cttBtatcatatgctaKggNcataaaSatgtaaaDcDRtBggDtctttataattcBgtcg
    tactDtDagcctatttSVHtHttKtgtHMaSattgWaHKHttttagacatWatgtRgaaa
    NtactMcSMtYtcMgRtacttctWBacgaaatatagScDtttgaagacacatagtVgYgt
    cattHWtMMWcStgttaggKtSgaYaaccWStcgBttgcgaMttBYatcWtgacaYcaga
    gtaBDtRacttttcWatMttDBcatWtatcttactaBgaYtcttgttttttttYaaScYa
    HgtgttNtSatcMtcVaaaStccRcctDaataataStcYtRDSaMtDttgttSagtRRca
    tttHatSttMtWgtcgtatSSagactYaaattcaMtWatttaSgYttaRgKaRtccactt
    tattRggaMcDaWaWagttttgacatgttctacaaaRaatataataaMttcgDacgaSSt
    acaStYRctVaNMtMgtaggcKatcttttattaaaaagVWaHKYagtttttatttaacct
    tacgtVtcVaattVMBcttaMtttaStgacttagattWWacVtgWYagWVRctDattBYt
    gtttaagaagattattgacVatMaacattVctgtBSgaVtgWWggaKHaatKWcBScSWa
    accRVacacaaactaccScattRatatKVtactatatttHttaagtttSKtRtacaaagt
    RDttcaaaaWgcacatWaDgtDKacgaacaattacaRNWaatHtttStgttattaaMtgt
    tgDcgtMgcatBtgcttcgcgaDWgagctgcgaggggVtaaScNatttacttaatgacag
    cccccacatYScaMgtaggtYaNgttctgaMaacNaMRaacaaacaKctacatagYWctg
    ttWaaataaaataRattagHacacaagcgKatacBttRttaagtatttccgatctHSaat
    actcNttMaagtattMtgRtgaMgcataatHcMtaBSaRattagttgatHtMttaaKagg
    YtaaBataSaVatactWtataVWgKgttaaaacagtgcgRatatacatVtHRtVYataSa
    KtWaStVcNKHKttactatccctcatgWHatWaRcttactaggatctataDtDHBttata
    aaaHgtacVtagaYttYaKcctattcttcttaataNDaaggaaaDYgcggctaaWSctBa
    aNtgctggMBaKctaMVKagBaactaWaDaMaccYVtNtaHtVWtKgRtcaaNtYaNacg
    gtttNattgVtttctgtBaWgtaattcaagtcaVWtactNggattctttaYtaaagccgc
    tcttagHVggaYtgtNcDaVagctctctKgacgtatagYcctRYHDtgBattDaaDgccK
    tcHaaStttMcctagtattgcRgWBaVatHaaaataYtgtttagMDMRtaataaggatMt
    ttctWgtNtgtgaaaaMaatatRtttMtDgHHtgtcattttcWattRSHcVagaagtacg
    ggtaKVattKYagactNaatgtttgKMMgYNtcccgSKttctaStatatNVataYHgtNa
    BKRgNacaactgatttcctttaNcgatttctctataScaHtataRagtcRVttacDSDtt
    aRtSatacHgtSKacYagttMHtWataggatgactNtatSaNctataVtttRNKtgRacc
    tttYtatgttactttttcctttaaacatacaHactMacacggtWataMtBVacRaSaatc
    cgtaBVttccagccBcttaRKtgtgcctttttRtgtcagcRttKtaaacKtaaatctcac
    aattgcaNtSBaaccgggttattaaBcKatDagttactcttcattVtttHaaggctKKga
    tacatcBggScagtVcacattttgaHaDSgHatRMaHWggtatatRgccDttcgtatcga
    aacaHtaagttaRatgaVacttagattVKtaaYttaaatcaNatccRttRRaMScNaaaD
    gttVHWgtcHaaHgacVaWtgttScactaagSgttatcttagggDtaccagWattWtRtg
    ttHWHacgattBtgVcaYatcggttgagKcWtKKcaVtgaYgWctgYggVctgtHgaNcV
    taBtWaaYatcDRaaRtSctgaHaYRttagatMatgcatttNattaDttaattgttctaa
    ccctcccctagaWBtttHtBccttagaVaatMcBHagaVcWcagBVttcBtaYMccagat
    gaaaaHctctaacgttagNWRtcggattNatcRaNHttcagtKttttgWatWttcSaNgg
    gaWtactKKMaacatKatacNattgctWtatctaVgagctatgtRaHtYcWcttagccaa
    tYttWttaWSSttaHcaaaaagVacVgtaVaRMgattaVcDactttcHHggHRtgNcctt
    tYatcatKgctcctctatVcaaaaKaaaagtatatctgMtWtaaaacaStttMtcgactt
    taSatcgDataaactaaacaagtaaVctaggaSccaatMVtaaSKNVattttgHccatca
    cBVctgcaVatVttRtactgtVcaattHgtaaattaaattttYtatattaaRSgYtgBag
    aHSBDgtagcacRHtYcBgtcacttacactaYcgctWtattgSHtSatcataaatataHt
    cgtYaaMNgBaatttaRgaMaatatttBtttaaaHHKaatctgatWatYaacttMctctt
    ttVctagctDaaagtaVaKaKRtaacBgtatccaaccactHHaagaagaaggaNaaatBW
    attccgStaMSaMatBttgcatgRSacgttVVtaaDMtcSgVatWcaSatcttttVatag
    ttactttacgatcaccNtaDVgSRcgVcgtgaacgaNtaNatatagtHtMgtHcMtagaa
    attBgtataRaaaacaYKgtRccYtatgaagtaataKgtaaMttgaaRVatgcagaKStc
    tHNaaatctBBtcttaYaBWHgtVtgacagcaRcataWctcaBcYacYgatDgtDHccta
    >THREE Homo sapiens frequency
    aacacttcaccaggtatcgtgaaggctcaagattacccagagaacctttgcaatataaga
    atatgtatgcagcattaccctaagtaattatattctttttctgactcaaagtgacaagcc
    ctagtgtatattaaatcggtatatttgggaaattcctcaaactatcctaatcaggtagcc
    atgaaagtgatcaaaaaagttcgtacttataccatacatgaattctggccaagtaaaaaa
    tagattgcgcaaaattcgtaccttaagtctctcgccaagatattaggatcctattactca
    tatcgtgtttttctttattgccgccatccccggagtatctcacccatccttctcttaaag
    gcctaatattacctatgcaaataaacatatattgttgaaaattgagaacctgatcgtgat
    tcttatgtgtaccatatgtatagtaatcacgcgactatatagtgctttagtatcgcccgt
    gggtgagtgaatattctgggctagcgtgagatagtttcttgtcctaatatttttcagatc
    gaatagcttctatttttgtgtttattgacatatgtcgaaactccttactcagtgaaagtc
    atgaccagatccacgaacaatcttcggaatcagtctcgttttacggcggaatcttgagtc
    taacttatatcccgtcgcttactttctaacaccccttatgtatttttaaaattacgttta
    ttcgaacgtacttggcggaagcgttattttttgaagtaagttacattgggcagactcttg
    acattttcgatacgactttctttcatccatcacaggactcgttcgtattgatatcagaag
    ctcgtgatgattagttgtcttctttaccaatactttgaggcctattctgcgaaatttttg
    ttgccctgcgaacttcacataccaaggaacacctcgcaacatgccttcatatccatcgtt
    cattgtaattcttacacaatgaatcctaagtaattacatccctgcgtaaaagatggtagg
    ggcactgaggatatattaccaagcatttagttatgagtaatcagcaatgtttcttgtatt
    aagttctctaaaatagttacatcgtaatgttatctcgggttccgcgaataaacgagatag
    attcattatatatggccctaagcaaaaacctcctcgtattctgttggtaattagaatcac
    acaatacgggttgagatattaattatttgtagtacgaagagatataaaaagatgaacaat
    tactcaagtcaagatgtatacgggatttataataaaaatcgggtagagatctgctttgca
    attcagacgtgccactaaatcgtaatatgtcgcgttacatcagaaagggtaactattatt
    aattaataaagggcttaatcactacatattagatcttatccgatagtcttatctattcgt
    tgtatttttaagcggttctaattcagtcattatatcagtgctccgagttctttattattg
    ttttaaggatgacaaaatgcctcttgttataacgctgggagaagcagactaagagtcgga
    gcagttggtagaatgaggctgcaaaagacggtctcgacgaatggacagactttactaaac
    caatgaaagacagaagtagagcaaagtctgaagtggtatcagcttaattatgacaaccct
    taatacttccctttcgccgaatactggcgtggaaaggttttaaaagtcgaagtagttaga
    ggcatctctcgctcataaataggtagactactcgcaatccaatgtgactatgtaatactg
    ggaacatcagtccgcgatgcagcgtgtttatcaaccgtccccactcgcctggggagacat
    gagaccacccccgtggggattattagtccgcagtaatcgactcttgacaatccttttcga
    ttatgtcatagcaatttacgacagttcagcgaagtgactactcggcgaaatggtattact
    aaagcattcgaacccacatgaatgtgattcttggcaatttctaatccactaaagcttttc
    cgttgaatctggttgtagatatttatataagttcactaattaagatcacggtagtatatt
    gatagtgatgtctttgcaagaggttggccgaggaatttacggattctctattgatacaat
    ttgtctggcttataactcttaaggctgaaccaggcgtttttagacgacttgatcagctgt
    tagaatggtttggactccctctttcatgtcagtaacatttcagccgttattgttacgata
    tgcttgaacaatattgatctaccacacacccatagtatattttataggtcatgctgttac
    ctacgagcatggtattccacttcccattcaatgagtattcaacatcactagcctcagaga
    tgatgacccacctctaataacgtcacgttgcggccatgtgaaacctgaacttgagtagac
    gatatcaagcgctttaaattgcatataacatttgagggtaaagctaagcggatgctttat
    ataatcaatactcaataataagatttgattgcattttagagttatgacacgacatagttc
    actaacgagttactattcccagatctagactgaagtactgatcgagacgatccttacgtc
    gatgatcgttagttatcgacttaggtcgggtctctagcggtattggtacttaaccggaca
    ctatactaataacccatgatcaaagcataacagaatacagacgataatttcgccaacata
    tatgtacagaccccaagcatgagaagctcattgaaagctatcattgaagtcccgctcaca
    atgtgtcttttccagacggtttaactggttcccgggagtcctggagtttcgacttacata
    aatggaaacaatgtattttgctaatttatctatagcgtcatttggaccaatacagaatat
    tatgttgcctagtaatccactataacccgcaagtgctgatagaaaatttttagacgattt
    ataaatgccccaagtatccctcccgtgaatcctccgttatactaattagtattcgttcat
    acgtataccgcgcatatatgaacatttggcgataaggcgcgtgaattgttacgtgacaga
    gatagcagtttcttgtgatatggttaacagacgtacatgaagggaaactttatatctata
    gtgatgcttccgtagaaataccgccactggtctgccaatgatgaagtatgtagctttagg
    tttgtactatgaggctttcgtttgtttgcagagtataacagttgcgagtgaaaaaccgac
    gaatttatactaatacgctttcactattggctacaaaatagggaagagtttcaatcatga
    gagggagtatatggatgctttgtagctaaaggtagaacgtatgtatatgctgccgttcat
    tcttgaaagatacataagcgataagttacgacaattataagcaacatccctaccttcgta
    acgatttcactgttactgcgcttgaaatacactatggggctattggcggagagaagcaga
    tcgcgccgagcatatacgagacctataatgttgatgatagagaaggcgtctgaattgata
    catcgaagtacactttctttcgtagtatctctcgtcctctttctatctccggacacaaga
    attaagttatatatatagagtcttaccaatcatgttgaatcctgattctcagagttcttt
    ggcgggccttgtgatgactgagaaacaatgcaatattgctccaaatttcctaagcaaatt
    ctcggttatgttatgttatcagcaaagcgttacgttatgttatttaaatctggaatgacg
    gagcgaagttcttatgtcggtgtgggaataattcttttgaagacagcactccttaaataa
    tatcgctccgtgtttgtatttatcgaatgggtctgtaaccttgcacaagcaaatcggtgg
    tgtatatatcggataacaattaatacgatgttcatagtgacagtatactgatcgagtcct
    ctaaagtcaattacctcacttaacaatctcattgatgttgtgtcattcccggtatcgccc
    gtagtatgtgctctgattgaccgagtgtgaaccaaggaacatctactaatgcctttgtta
    ggtaagatctctctgaattccttcgtgccaacttaaaacattatcaaaatttcttctact
    tggattaactacttttacgagcatggcaaattcccctgtggaagacggttcattattatc
    ggaaaccttatagaaattgcgtgttgactgaaattagatttttattgtaagagttgcatc
    tttgcgattcctctggtctagcttccaatgaacagtcctcccttctattcgacatcgggt
    ccttcgtacatgtctttgcgatgtaataattaggttcggagtgtggccttaatgggtgca
    actaggaatacaacgcaaatttgctgacatgatagcaaatcggtatgccggcaccaaaac
    gtgctccttgcttagcttgtgaatgagactcagtagttaaataaatccatatctgcaatc
    gattccacaggtattgtccactatctttgaactactctaagagatacaagcttagctgag
    accgaggtgtatatgactacgctgatatctgtaaggtaccaatgcaggcaaagtatgcga
    gaagctaataccggctgtttccagctttataagattaaaatttggctgtcctggcggcct
    cagaattgttctatcgtaatcagttggttcattaattagctaagtacgaggtacaactta
    tctgtcccagaacagctccacaagtttttttacagccgaaacccctgtgtgaatcttaat
    atccaagcgcgttatctgattagagtttacaactcagtattttatcagtacgttttgttt
    ccaacattacccggtatgacaaaatgacgccacgtgtcgaataatggtctgaccaatgta
    ggaagtgaaaagataaatat

=end pod

constant IM = 139968;
constant IA = 3877;
constant IC = 29573;
constant LINELENGTH = 60;

my $Seed = 42;

my @iub = (
    ['a', 0.27], ['c', 0.12], ['g', 0.12],
    ['t', 0.27], ['B', 0.02], ['D', 0.02],
    ['H', 0.02], ['K', 0.02], ['M', 0.02],
    ['N', 0.02], ['R', 0.02], ['S', 0.02],
    ['V', 0.02], ['W', 0.02], ['Y', 0.02]
);

my @homosapiens = (
    ['a', 0.3029549426680],
    ['c', 0.1979883004921],
    ['g', 0.1975473066391],
    ['t', 0.3015094502008]
);

my $alu = 'GGCCGGGCGCGGTGGCTCACGCCTGTAATCCCAGCACTTTGG' ~
          'GAGGCCGAGGCGGGCGGATCACCTGAGGTCAGGAGTTCGAGA' ~
          'CCAGCCTGGCCAACATGGTGAAACCCCGTCTCTACTAAAAAT' ~
          'ACAAAAATTAGCCGGGCGTGGTGGCGCGCGCCTGTAATCCCA' ~
          'GCTACTCGGGAGGCTGAGGCAGGAGAATCGCTTGAACCCGGG' ~
          'AGGCGGAGGTTGCAGTGAGCCGAGATCGCGCCACTGCACTCC' ~
          'AGCCTGGGCGACAGAGCGAGACTCCGTCTCAAAAA';

my $n = (@*ARGS[0] || 1000) ;

makeCumulative(@iub);
makeCumulative(@homosapiens);

makeRepeatFasta('ONE', 'Homo sapiens alu', $n*2, $alu);
makeRandomFasta('TWO', 'IUB ambiguity codes', $n*3, @iub);
makeRandomFasta('THREE', 'Homo sapiens frequency', $n*5, @homosapiens);

sub makeCumulative(@genelist) {
    my $cp = 0.0;
    for @genelist -> @gene {
        @gene[1] = $cp += @gene[1];
    }
}

sub makeRepeatFasta($id, $desc, $n, $s) {
    say ">$id $desc";

    my $r = $s.chars;
    my $ss = $s ~ $s ~ $s.substr(0, $n % $r);

    for 0..($n div LINELENGTH)-1 -> $k {
        my $i = $k*LINELENGTH % $r;
        say $ss.substr($i, LINELENGTH);
    }
    if ($n % LINELENGTH) {
        say $ss.substr(*-($n % LINELENGTH));
    }
}

sub makeRandomFasta($id, $desc, $n, @genelist) {
    say ">$id $desc";

    # print whole lines
    for 1 .. ($n div LINELENGTH) {
        say selectRandom(@genelist, LINELENGTH);
    }
    # print remaining line (if required)
    if ($n % LINELENGTH) {
        say selectRandom(@genelist, $n % LINELENGTH);
    }
}

sub selectRandom(@genelist, $length) {
    my @rand = gen_random($length);
    my $seq = '';

    for @rand -> $rand {
        for @genelist -> @gene {
            if ($rand < @gene[1]) { $seq ~= @gene[0]; last; }
        }
    }
    return $seq;
}

sub gen_random($length) {
    map {
        $Seed = ($Seed * IA + IC) % IM;
        $Seed / IM;
    } , 1..$length;
}

# vim: expandtab shiftwidth=4 ft=perl6
