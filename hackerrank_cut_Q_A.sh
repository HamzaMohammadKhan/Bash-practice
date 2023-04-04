#Given a tab delimited file with several columns (tsv format) print the first three fields.
cut -f 1-3

#Given  lines of input, print the  character from each line as a new line of output. It is guaranteed that each of the  lines of input will have a  character.
cut -c3

#Display the  and  character from each line of text.
cut -c 2,7

#Display a range of characters starting at the  position of a string and ending at the  position (both positions included).
cut -c 2-7

#Display the first four characters from each line of text.
cut -c -4

#Print the characters from thirteenth position to the end.
cut -c 13-

#Given a sentence, identify and display its fourth word. Assume that the space (' ') is the only delimiter between words.
cut -d " " -f 4
