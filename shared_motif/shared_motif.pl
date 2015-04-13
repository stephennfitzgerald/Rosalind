use strict;

my(%Xmers,$ct,@SEQS,$index);
my$min_size=10e6;
{
 local $/=undef;
 while(<>){
  foreach my$fasta(split(">",$_)){
   next unless($fasta);
   my($hd,@seq)=split("\n",$fasta);
   ($min_size,$index) = @seq < $min_size ? (@seq,$ct) : ($min_size,$index);
   push(@SEQS,[$hd,join("",@seq)]);
   $ct++;
  }
 }
}

xmers(@{splice(@SEQS,$index,1)},0);
foreach my$fasta(@SEQS){
 xmers(@$fasta,1);
}

my($min_len,$max_xmer);
foreach my$xmer(keys %Xmers){
 next unless ($ct == (keys %{$Xmers{$xmer}}));
 if(length($xmer) > $min_len){
  $max_xmer = $xmer;
  $min_len = length($xmer);
 }
}

print $max_xmer, "\n";

sub xmers{
 my($hd,$seq,$test)=@_;
 for(my$i=0;$i<length($seq);$i++){
  for(my$k=1;$k<=length($seq)-$i;$k++){
   if($test){
    next unless(exists($Xmers{ substr($seq,$i,$k) }));
   }
   $Xmers{ substr($seq,$i,$k) }{$hd}++;
  }
 }
}
