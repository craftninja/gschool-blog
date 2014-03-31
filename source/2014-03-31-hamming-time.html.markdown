---
title: Hamming Time
date: 2014-03-31 05:43 UTC
tags: Ruby, Exercism, DNA, code
---

So in my previous post I mentioned [Exercism](http://exercism.io/). This website consists of a series of coding challenges in several different coding languages. My chosen track is Ruby, of course. Again, the list of exercises in this track is at [GitHub](https://github.com/exercism/xruby/blob/master/EXERCISES.txt).

I have worked through several of the exercises thus far. One whose very premise made me happy was the Hamming exercise... put in two lengths of DNA and calculate their [Hamming distance](http://en.wikipedia.org/wiki/Hamming_distance). In one of my previous incarnations, I worked in a lab [tossing plasmids into sweet innocent bacterial strains](http://en.wikipedia.org/wiki/Molecular_cloning)... slave labour to manufacture proteins. Anyway, I knew exactly what this exercise was trying to measure.

Following is the README, or basic instructions of the exercise:
***
> Write a program that can calculate the Hamming difference between two DNA strands.
>
> A mutation is simply a mistake that occurs during the creation or copying of a nucleic acid, in particular DNA. Because nucleic acids are vital to cellular functions, mutations tend to cause a ripple effect throughout the cell. Although mutations are technically mistakes, a very rare mutation may equip the cell with a beneficial attribute. In fact, the macro effects of evolution are attributable by the accumulated result of beneficial microscopic mutations over many generations.
>
> The simplest and most common type of nucleic acid mutation is a point mutation, which replaces one base with another at a single nucleotide.
>
> By counting the number of differences between two homologous DNA strands taken from different genomes with a common ancestor, we get a measure of the minimum number of point mutations that could have occurred on the evolutionary path between the two strands.
>
> This is called the 'Hamming distance'
***

My first iteration of this exercise is as follows:

***
<pre><code>
class Hamming
  def self.compute(dna_strand_1, dna_strand_2)
    dna_strand_1_array = dna_strand_1.split(//)
    dna_strand_2_array = dna_strand_2.split(//)

    length_shortest_strand = dna_strand_1.length
    length_shortest_strand = dna_strand_2.length if dna_strand_2.length < dna_strand_1.length

    i=0
    hamming_distance = 0

    while i < length_shortest_strand
      if dna_strand_1_array[i] != dna_strand_2_array[i]
        hamming_distance = hamming_distance+1
      end
      i+=1
    end

    hamming_distance
  end
end
</code></pre>
***

In my second iteration, I realized that there is no need to split the DNA strand into an array due to the each\_char method. In addition, iterating to the end of strand 1 and ensuring that we were comparing to an existing base pair in strand 2, the length\_shortest\_strand variable could be eliminated.

***
<pre><code>
class Hamming
  def self.compute(dna_strand_1, dna_strand_2)
    i = 0
    hamming_distance = 0
    dna_strand_1.each_char do |x|
      hamming_distance += 1 if dna_strand_2.byteslice(i) != x && dna_strand_2.byteslice(i) != nil
      i += 1
    end

    hamming_distance
  end
end
</code></pre>
***

My last iteration utilized the with\_index method to eliminate the iterator variable. I also assigned the individual base pairs that were being compared to the variable base\_pair\_a and base\_pair\_b for more readability.

***
<pre><code>
class Hamming
  def self.compute(dna_strand_a, dna_strand_b)
    hamming_distance = 0
    dna_strand_a.each_char.with_index do |base_pair_a, i|
      base_pair_b = dna_strand_b[i]
      hamming_distance += 1 if base_pair_b != base_pair_a && base_pair_b != nil
    end
    hamming_distance
  end
end
</code></pre>
***

This was a fun exercise!