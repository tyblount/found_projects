#bioinfo bash script
sudo apt-get install samtools
sudo apt-get install bwa
sudo apt-get install bcftools
sudo apt-get install datamash
sudo apt-get install bc

bwa_ref="./bwa/hg19.fa"
bcf_ref="./seq/hg19.fa" 

sample_name=$1

bwa mem $bwa_ref ${sample_name}_1.fq ${sample_name}_2.fq > ${sample_name}.sam

for i in 5 10 17 18 19 20 21 22 23 24; do bwa mem -W $i $bwa_ref ${sample_name}_1.fq ${sample_name}_2.fq > ${sample_name}_W$i.sam; done
##script btwn the double-# was created with the help of chat gpt.
# Set the given base for the exponential function
base=2
# Set the starting value
starting_value=25
# Set the maximum value for the list
max_read=$(grep -v '^@' ${sample_name}.sam | cut -f 10 | awk '{n=split($0,chars,""); print n}' | datamash max 1) #sets the variable max equal to the longest read in the sam file

# Generate a list of numbers using an exponential function starting from 25
i=0
while true; do
    result=$(echo "$base^$i + $starting_value" | bc)
    
    # Break the loop if the result exceeds the maximum value
    if ((result > max_read)); then
        break
    fi
    
    numbers[$i]=$result
    ((i++))
done

# Use the generated numbers in a for loop
for ((j = 0; j < i; j++)); do
    bwa mem -W ${numbers[$j]} $bwa_ref ${sample_name}_1.fq ${sample_name}_2.fq > ${sample_name}_W${numbers[$j]}.sam
done
##

for k in ${sample_name}_W*.sam; do l=$(echo "$k" | sed 's/\.[^.]*$//'); samtools sort $k > ${l}_s.bam; done

for f in ${sample_name}_W*_s.bam; do l=$(echo "$f" | sed 's/\.[^.]*$//'); bcftools mpileup -Ou -f $bcf_ref $f | bcftools call -vmO v -o ${l}.vcf; done
